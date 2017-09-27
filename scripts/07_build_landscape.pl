#!/usr/bin/env perl
use warnings;
use strict;

use Pod::Usage;
use Getopt::Long;
use Log::Log4perl qw(:no_extra_logdie_message);
use Log::Log4perl::Level;

use List::Util qw(first max maxstr min minstr reduce shuffle sum);
use Data::Dumper;
use FindBin qw($Script);

use File::Basename;
use File::Which;

use Sam::Parser 0.11;
use Sam::Alignment 0.10 ':flags';
use Sam::Seq 0.16;

use Fasta::Parser;
use Fasta::Seq;

use Fastq::Parser;
use Fastq::Seq;

our $VERSION  = '0.0.1';



=head1 NAME

build repeat landscape

=cut

=head1 DESCRIPTION

This script reads the mapping counts, the cluster and class information
and results in a tab separated file, containing the data for the repeat
landscape.

=head1 SYNOPSIS

  build_repeat_landscape [options] --clstr <repeats.exemplars.clstr> --fasta <repeats.exemplars.classified> --bam <mapping.bam>

=head1 OPTIONS

=over

=item --clstr

The cluster information file resulted from cd-hit (required)

=item --fasta

The classified exemplar sequences (required)

=item --bam

The mapping counts as sorted bam file (required, index should be present, too)

=item [--out]

set filename prefix for output (default: repeat-landscape)
Three files will be generated:
<prefix>_by-sequence.tab
<prefix>_by-cluster.tab
<prefix>_by-class.tab

=item [--coverage]

Expected genomics coverage in reads used for mapping (default: 80)
This metric will be used for the estimation of the genomic content
of the repeats

=item [--readLength]

Average read length of reads used for mapping (default: 100)
This metric will be used for the estimation of the genomic content
of the repeats

=item [--samtools]

path to samtools binary

=item [-D/--debug]

Toggle verbose messages.

=item [-h/--help]

Display this help screen.

=item [-V/--version]

Display script version.

=back

=cut

##----------------------------------------------------------------------------##
# Globals

Log::Log4perl->init( \(q(
        log4perl.rootLogger                     = INFO, Screen
        log4perl.appender.Screen                = Log::Log4perl::Appender::Screen
        log4perl.appender.Screen.stderr         = 1
        log4perl.appender.Screen.layout         = PatternLayout
        log4perl.appender.Screen.layout.ConversionPattern = [%d{yy-MM-dd HH:mm:ss}] [).$Script.q(] %m%n
)));

my $L = Log::Log4perl->get_logger();

##----------------------------------------------------------------------------##
# GetOptions

my $argv = join(" ", @ARGV);

my %def = ();

my %opt = (
#    bam => undef
);

GetOptions(
    \%opt, qw(
                 out=s
                 bam=s
                 clstr=s
                 fasta=s
                 coverage=s
                 readLength=s
                 samtools=s
                 version|V!
                 debug|D!
                 help|h!
         )
    ) or $L->logcroak('Failed to "GetOptions"');

# help
$opt{help} && pod2usage(1);

# version
if ($opt{version}) {
    print "$VERSION\n";
    exit 0;
}

##----------------------------------------------------------------------------##
# Config + Opt

%opt = (%def, %opt);

$opt{bam} = shift(@ARGV) if @ARGV;
$L->logdie("unused argument: @ARGV") if @ARGV;

# required stuff
for (qw(bam fasta clstr)) {
    if (ref $opt{$_} eq 'ARRAY') {
	pod2usage("required: --$_") unless @{$opt{$_}}
    } else {
	pod2usage("required: --$_") unless defined ($opt{$_})
    }
};

$opt{out} = "repeat-landscape" unless $opt{out};
$opt{coverage} = 80 unless $opt{coverage};
$opt{readLength} = 100 unless $opt{readLength};


# debug level
$L->level($DEBUG) if $opt{debug};
$L->debug('Verbose level set to DEBUG');

$L->debug(Dumper(\%opt));


$L->info("Checking binaries");
# check DAZZ_DB binaries
my$samtools=$opt{samtools};
$samtools = bin("samtools") unless $opt{samtools};
$L->debug("found samtools at $samtools");
check_binary($samtools, ["--version", "1.1"]);

##------------------------------------------------------------------------##

=head1 MAIN

=cut

# read fasta file
$L->info("reading fasta file");
my$fasta=Fasta::Parser->new(file => $opt{fasta});
my%fasta;
while(my$seqObj=$fasta->next_seq())
{
    ## put everything in a hash
    my($id,$class)=$seqObj->id()=~/>?(\S+)#(\S+)/;
    (my$length)=$seqObj->desc()=~/len=(\d+)/;
    $fasta{$id}={'class' => $class,
		 'length' => $length};
}

##----------------------------------------------------------------------------##
# read cluster file
$L->info("reading cluster file");
my%clstr;
open(CLSTR,'<',$opt{clstr}) or $L->logdie($!);
$/="\n>";
while(<CLSTR>)
{
    chomp;
    my@obj=split(/\n/,$_);
    my$name=shift(@obj);
    (my$id)=$name=~/Cluster\s+(\d+)/;
    my$headID;
    foreach my$line (@obj)
    {
	# get ID of head sequence -> neccessary to assign a class
	($headID)=$line=~/>(c.*)\.{3}/ if $line=~/\*\s*$/;
    }
    foreach my$seq (@obj)
    {
	#loop through sequences in cluster to extract length and IDs
	#and write all to the clstr hash
	(my$seqID)=$seq=~/>(c.*)\.{3}/;
	(my$length)=$seq=~/(\d+)nt/;
	my$head=0;
	$head=1 if $seqID eq $headID;
	
	$clstr{$id}{$seqID}={'length'=> $length,
			     'class' => $fasta{$headID}{'class'},
			     'head' => $head};
    }
}
$/="\n";
close CLSTR or $L->logdie($!);

##----------------------------------------------------------------------------##
unless ( -e $opt{bam}.".bai" ) {
    my $sam_idx = "$samtools index $opt{bam}.bai";
    $L->debug($sam_idx);
    qx($sam_idx);
}

# init sam parser
my $sam_cmd = "$samtools view -H $opt{bam} |";
$L->debug($sam_cmd);
open(SAM, $sam_cmd) or $L->logdie($!);
my $sp = Sam::Parser->new(fh => \*SAM);

##----------------------------------------------------------------------------##
# read header

$L->info("reading BAM header");
my %R;
my @R_IDS;

while (my %h = $sp->next_header_line) {
    if (exists $h{SN}) {
        push @R_IDS, $h{SN};
        $R{$h{'SN'}} = {
            id => $h{SN},
            len => $h{LN},
        };
    }
}

$L->info("Bam file contains ".@R_IDS." reference sequences");

##----------------------------------------------------------------------------##
# read BAM

my $rn = @R_IDS;
my ($rc, $ac, $sc);
my $rc5 = int(($rn/20)+.5);
$rc5=1 if $rc5==0;
my $rc5c;
my $rcl = length($rn);


REF:
foreach my $rid(@R_IDS){
    $rc++;
    $L->info(sprintf(" %3d%% [%${rcl}d]", (++$rc5c * 5), $rc)) unless $rc % $rc5;
    open(SAM, "$samtools view $opt{bam} $rid |") or $L->logdie($!);
    my $sp = Sam::Parser->new(fh => \*SAM);

    (my$seqID)=$rid=~/(\S+)(#.*)?/;

    my$count;
    while(my $aln = $sp->next_aln()){
	#count alignments per reference
	$L->logdie("$rid ne $aln->rname") unless $rid eq $aln->rname;
	$count++;
    }	
    
    foreach my$clstrID (keys %clstr)
    {
	#add alignment count to corresponding sequence in clstr hash
	#and go to next reference, if written to hash
	if(exists $clstr{$clstrID}{$seqID})
	{
	    $L->logdie($seqID," already has a count!") if defined $clstr{$clstrID}{$seqID}{'count'};
	    $clstr{$clstrID}{$seqID}{'count'}=$count;
	    next REF;
	}
    }
    close SAM;
}
$L->info(sprintf(" %3d%% [%${rcl}d]", (++$rc5c * 5), $rc)) if $rc5c < 20;


##----------------------------------------------------------------------------##
# output
$L->info("writing output");
my%classes;

open(BYSEQ,'>',$opt{out}."_by-sequence.tab") or $L->logdie($!);
print BYSEQ join("\t", qw(seqID count length[bp] genomPart[Kbp] clstrID class)),"\n";
open(BYCLSTR,'>',$opt{out}."_by-cluster.tab") or $L->logdie($!);
print BYCLSTR join("\t", qw(clstrID count size[bp] size[numSeqs] genomPart[Mbp] class)),"\n";
foreach my$clstrID (keys%clstr)
{
    my$sumCounts=0;
    my$sizeBp=0;
    my$sizeSeqs=0;
    my$class='';
    foreach my$seqID (keys %{$clstr{$clstrID}})
    {
	# set count to 0 if the sequence has no count field (did not occur in the bam file.)
	# use defined here, because the value is undef, which leads exists to evaluate true
	$clstr{$clstrID}{$seqID}{'count'}=0 unless defined $clstr{$clstrID}{$seqID}{'count'};
	

	#print by sequence
	print BYSEQ join("\t", $seqID,
			 $clstr{$clstrID}{$seqID}{'count'},
			 $clstr{$clstrID}{$seqID}{'length'},
			 sprintf("%.2f",(($clstr{$clstrID}{$seqID}{'count'}/$opt{coverage})*$opt{readLength})/(10**3)),
			 $clstrID,
			 $clstr{$clstrID}{$seqID}{'class'}),"\n";

	#calculate metrics for output by cluster
	$sumCounts+=$clstr{$clstrID}{$seqID}{'count'};
	$sizeBp+=$clstr{$clstrID}{$seqID}{'length'};
	$sizeSeqs++;
	$L->logdie("no distinct class found for cluster ",$clstrID) if $class && $class ne $clstr{$clstrID}{$seqID}{'class'};
	$class=$clstr{$clstrID}{$seqID}{'class'};

	#fill classes hash for printing by class
	if($clstr{$clstrID}{$seqID}{'class'}=~/^DNA/)
	{
	    $classes{'DNA'}{'count'}+=$clstr{$clstrID}{$seqID}{'count'};
	    $classes{'DNA'}{'numBp'}+=$clstr{$clstrID}{$seqID}{'length'};
	    $classes{'DNA'}{'numSeqs'}++;
	}
 	elsif($clstr{$clstrID}{$seqID}{'class'}=~/^LTR/)
	{
	    if($clstr{$clstrID}{$seqID}{'class'} eq 'LTR/Copia')
	    {
		$classes{'LTR/Copia'}{'count'}+=$clstr{$clstrID}{$seqID}{'count'};
	    $classes{'LTR/Copia'}{'numBp'}+=$clstr{$clstrID}{$seqID}{'length'};
	    $classes{'LTR/Copia'}{'numSeqs'}++;
	    }
	    elsif($clstr{$clstrID}{$seqID}{'class'} eq 'LTR/Gypsy')
	    {
		$classes{'LTR/Gypsy'}{'count'}+=$clstr{$clstrID}{$seqID}{'count'};
	    $classes{'LTR/Gypsy'}{'numBp'}+=$clstr{$clstrID}{$seqID}{'length'};
	    $classes{'LTR/Gypsy'}{'numSeqs'}++;
	    }
	    else
	    {
		$classes{'LTR/other'}{'count'}+=$clstr{$clstrID}{$seqID}{'count'};
	    $classes{'LTR/other'}{'numBp'}+=$clstr{$clstrID}{$seqID}{'length'};
	    $classes{'LTR/other'}{'numSeqs'}++;
	    }
	}
	elsif($clstr{$clstrID}{$seqID}{'class'}=~/^LINE/)
	{
	    $classes{'LINE'}{'count'}+=$clstr{$clstrID}{$seqID}{'count'};
	    $classes{'LINE'}{'numBp'}+=$clstr{$clstrID}{$seqID}{'length'};
	    $classes{'LINE'}{'numSeqs'}++;
	}
	elsif($clstr{$clstrID}{$seqID}{'class'}=~/^SINE/)
	{
	    $classes{'SINE'}{'count'}+=$clstr{$clstrID}{$seqID}{'count'};
	    $classes{'SINE'}{'numBp'}+=$clstr{$clstrID}{$seqID}{'length'};
	    $classes{'SINE'}{'numSeqs'}++;
	}
	elsif($clstr{$clstrID}{$seqID}{'class'}=~/^Satellite/)
	{
	    $classes{'Satellite'}{'count'}+=$clstr{$clstrID}{$seqID}{'count'};
	    $classes{'Satellite'}{'numBp'}+=$clstr{$clstrID}{$seqID}{'length'};
	    $classes{'Satellite'}{'numSeqs'}++;
	}
	else
	{
	    $classes{$clstr{$clstrID}{$seqID}{'class'}}{'count'}+=$clstr{$clstrID}{$seqID}{'count'};
	    $classes{$clstr{$clstrID}{$seqID}{'class'}}{'numBp'}+=$clstr{$clstrID}{$seqID}{'length'};
	    $classes{$clstr{$clstrID}{$seqID}{'class'}}{'numSeqs'}++;
	}
    }
    
    #print by cluster
    print BYCLSTR join("\t", $clstrID,
		       $sumCounts,
		       $sizeBp,
		       $sizeSeqs,
		       sprintf("%.2f", (($sumCounts/$opt{coverage})*$opt{readLength})/(10**6)),
		       $class),"\n";
}

close BYCLSTR or $L->logdie($!);
close BYSEQ or $L->logdie($!);

#print by class
open(BYCLASS,'>',$opt{out}."_by-class.tab") or $L->logdie($!);
print BYCLASS join("\t", qw(class count numBp numSeqs genomPart[Mbp])),"\n";
foreach my$class (keys %classes)
{
    print BYCLASS join("\t",$class,
		       $classes{$class}{'count'},
		       $classes{$class}{'numBp'},
		       $classes{$class}{'numSeqs'},
		       sprintf("%.2f",(($classes{$class}{'count'}/$opt{coverage})*$opt{readLength})/(10**6))),"\n";
}
close BYCLASS or $L->logdie($!);


$L->info("finished program");


=head2 bin

Return full binary path based on $opt{<bin_path}.

=cut

sub bin{
    my ($bin) = @_;
    if (exists $opt{$bin."_path"} && $opt{$bin."_path"}) {
        return $opt{$bin."_path"}."/".$bin;
    } else {
        return $bin;
    }
}


=head2 check_binary

Check whether a required binary (and version) exists.

=cut

sub check_binary{
    my($bin, $ver) = (@_);
    my $fbin = $bin;
    unless(-e $fbin && -x $fbin){
        if ($fbin = which($bin)) {
            $L->logdie("Binary '$fbin' not executable") unless -e $fbin && -x $fbin;
        } else {
            $L->logdie("Binary '$bin' neither in PATH nor executable");
        }
    }

    $bin = basename($fbin);

    my $v;
    if ($ver) {
        $L->logdie("ARRAY ref required") unless ref $ver eq "ARRAY";

        my $vs = qx($fbin $ver->[0]);
        if ($? or ! $vs) {
            $L->logdie("Couldn't determine version of $bin, at least $ver->[1] required");
        }

        ($v) = $vs =~ /(\S+?)\D*$/m;

        if (version->parse($v) < version->parse($ver->[1])) {
            $L->logdie("Version $v of '$bin' < $v");
        }

    }

    $L->info(sprintf("  [ok] %-15s %s", $bin.($v ? "-$v" : ""), dirname($fbin)));

}


=head1 AUTHORS

Thomas Hackl S<thomas.hackl@uni-wuerzburg.de>
Niklas Terhoeven <niklas.terhoeven@uni-wuerzburg.de>

=cut
