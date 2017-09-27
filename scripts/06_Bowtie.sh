#!/bin/bash

source repeat_pipeline.cfg

export LD_LIBRARY_PATH='/software/bamtools/lib/':$LD_LIBRARY_PATH

#set memory limit to MAXMEMORY
noSuffix=$(echo "$MAXMEMORY" | sed -re 's/K|M|G|T//g')
limit=$(($noSuffix*1000000))
ulimit -v "$limit"


#build bowtie2 index
"$bowtieBuild" "$TRINITYOUT" "$TRINITYOUT"


#map reads to repeat library
"$bowtie2" --no-unal --reorder --sensitive-local --threads "$MAXTHREADS" -S mapped_reads.sam -x "$TRINITYOUT" -U "$READS1" -U "$READS2"


## convert sam to sorted and indexed bam
#sam-to-bam
"$samtools" view -b -o alignments.bam -@ "$MAXTHREADS" mapped_reads.sam
#sort bam
#-m 2GB memory per thread -@ 32 threads -O output bam 
"$samtools" sort -m 2G -o "$QUANTOUT" -T aa-temp -O bam -@ "$MAXTHREADS" alignments.bam
#index bam
"$samtools" index "$QUANTOUT"

echo "################################"
echo "finished mapping --> run build-landscape"
./00_run_repeat_pipeline.sh landscape