#!/usr/bin/perl

use strict;
use warnings;

my$blsFile=shift(@ARGV);

my%final;
my%high;
my%medium;
my%low;

open(IN,'<',$blsFile) or die $!;
while(<IN>)
{
    next if $_=~/^#/;

    my@line=split(/\s+/,$_);

    my$id=$line[0];

    (my$class)=$line[1]=~/^.+\|.+\|(.+)\|.+\|.+\|.+/;
    my$evalue=$line[10];

    if($evalue<=1e-3)
    {
	$high{$id}{$class}++;
    }
    elsif($evalue<=1)
    {
    	$medium{$id}{$class}++;
    }
    else
    {
	$low{$id}{$class}++;
    }
}
close IN or die $!;

&find_best(\%high,"high");
&find_best(\%medium,"medium");
&find_best(\%low,"low");

foreach my$id (keys %final)
{
    print join("\t",$id,$final{$id}{"class"},$final{$id}{"confidence"}),"\n";
}

sub find_best
{
    my%data=%{$_[0]};
    my$conf=$_[1];
    my%cutoff=("high" => 1,
	       "medium" => 3,
	       "low" => 5);
    
    foreach my$id (keys %data)
    {
	next if exists($final{$id});
	
	my@hits=sort{$data{$id}{$b} <=> $data{$id}{$a}} (keys %{$data{$id}});

	if($data{$id}{$hits[0]} >= $cutoff{$conf})
	{
	    $final{$id}{"class"}=$hits[0];
	    $final{$id}{"confidence"}=$conf;
	}
	else
	{
	    $final{$id}{"class"}="Unknown";
	    $final{$id}{"confidence"}=$conf;
	}
    }
}
