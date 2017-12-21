#!/bin/bash

source ./reper.conf
ulimit -v "$maxMemoryKB"


#build bowtie2 index
"$bowtieBuild" "$TRINITYOUT" "$TRINITYOUT"
if [ $? -ne 0 ]; then
    echo "########################"
    echo "bowtie build failed"
    exit 1
fi

"$bowtie2" --no-unal --reorder --sensitive-local --threads "$MAXTHREADS" -x "$TRINITYOUT" -U "$READS1" -U "$READS2" | "$samtools" view -b -@ "$MAXTHREADS" | "$samtools" sort -m "$maxMemoryKB"/"$MAXTHREADS" -o "$QUANTOUT" -T aa-temp -O bam -@ "$MAXTHREADS"

if [ $? -ne 0 ]; then
    echo "########################"
    echo "mapping failed"
    exit 1
fi

#index bam
"$samtools" index "$QUANTOUT"


if [ $? -eq 0 ]; then
    "$reperDir"/reper landscape
else
    echo "########################"
    echo "quantification failed"
    exit 1
fi

