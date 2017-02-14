#!/bin/bash

# This script is used to start my repeat pipeline
# call this script as
# run_repeat_pipeline.sh <job>
# with <job> as the next part to execute (jelly, kmerFilter, Trinity, cluster, classify, quantify, landscape, filtering)
# the jobs following the givien one are executed automatically
#
# please specify the files containing the reads (should be paired end Illumina)
# as well as the expected genomic coverage and the memory and CPU limits below

###

## read config
source repeat_pipeline.cfg

## define next job
STARTJOB="$1"

## run scripts
case "$STARTJOB" in
    jelly) ./01_Jellyfish.sh
	exit 0
	;;
    kmerFilter) ./02_Kmer-filter.sh
	exit 0
	;;
    Trinity) ./03_Trinity.sh "$FILTEROUT"_1.fq "$FILTEROUT"_2.fq
	exit 0
	;;
    cluster) ./04_cd-hit.sh 
	exit 0
	;;
    classify) ./05_Classifier.sh
	exit 0
	;;
    quantify) ./06_Bowtie.sh 
	exit 0
	;;
    landscape) ./07_build_landscape.pl --clstr "$CLUSTEROUT".clstr --fasta "$CLASSIFYOUT" --bam "$QUANTOUT" --coverage "$COVERAGE" --samtools "$samtools"
	exit 0
	;;
    filtering) ./08_filter-library.sh
	exit 0
	;;

    *) echo "$STARTJOB is not a valid job name!"
	echo "please select one of the following:"
	echo "jelly, kmerFilter, Trinity, cluster, classify, quantify, landscape, filtering"
	exit 1
	;;
esac

