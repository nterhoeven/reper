#!/bin/bash

source ./reper.conf

#export LD_LIBRARY_PATH='/software/bamtools/lib/':$LD_LIBRARY_PATH

ulimit -v "$maxMemoryKB"



#build bowtie2 index
"$bowtieBuild" "$TRINITYOUT" "$TRINITYOUT"


#map reads to repeat library
# "$bowtie2" --no-unal --reorder --sensitive-local --threads "$MAXTHREADS" -S mapped_reads.sam -x "$TRINITYOUT" -U "$READS1" -U "$READS2"


# ## convert sam to sorted and indexed bam
# #sam-to-bam
# "$samtools" view -b -o alignments.bam -@ "$MAXTHREADS" mapped_reads.sam
# #sort bam
# #-m 2GB memory per thread -@ 32 threads -O output bam 
# "$samtools" sort -m 2G -o "$QUANTOUT" -T aa-temp -O bam -@ "$MAXTHREADS" alignments.bam
# #index bam
# "$samtools" index "$QUANTOUT"

"$bowtie2" --no-unal --reorder --sensitive-local --threads "$MAXTHREADS" -x "$TRINITYOUT" -U "$READS1" -U "$READS2" | "$samtools" view -b -@ "$MAXTHREADS" | "$samtools" sort -m "$maxMemoryKB"/"$MAXTHREADS" -o "$QUANTOUT" -T aa-temp -O bam -@ "$MAXTHREADS"

#index bam
"$samtools" index "$QUANTOUT"



echo "################################"
echo "finished mapping --> run build-landscape"
"$reperDir"/reper landscape
