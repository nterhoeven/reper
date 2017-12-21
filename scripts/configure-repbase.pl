#!/usr/bin/perl

use strict;
use warnings;

my($setFile,$targetDir,$repBaseDir)=@ARGV;

print STDERR "set list: $setFile
repBase directory: $repBaseDir
output: $targetDir/$setFile.fa\n";

my@files=`find $repBaseDir -name "*.ref"`;

my@FilesNeeded;
my%set;


if($setFile eq "all")
{
    @FilesNeeded=@files;
}
else
{
    open(SET,'<',$setFile) or die $!;
    while(<SET>)
    {
	chomp;
	$set{$_}=1;
    }
    close SET or die $!;
}


foreach my$file (@files)
{
    chomp($file);
    my$filename=`basename $file`;
    chomp($filename);
    push(@FilesNeeded, $file) if exists $set{$filename};
}

open(OUT,'>',$targetDir."/".$setFile.".fa") or die $!;
foreach my$file (@FilesNeeded)
{
    open(IN,'<',$file) or die $!;
    while(<IN>)
    {
	if($_=~/^>/)
	{
	    chomp;
	    my@header=split(/\t/,$_);
	    if($file=~/simple.ref/)
	    {
		push(@header,"Simple-repeat");
		push(@header,"generic");
	    }
	    
	    foreach my$part (@header)
	    {
		$part=~s/\s+/-/g;
		print OUT $part,"|";
	    }
	    print OUT "\n";
	}
	else
	{
	    print OUT uc($_);
	}
    }
    close IN or die $!;
}
close OUT or die $!;
