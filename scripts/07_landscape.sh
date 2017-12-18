#!/bin/bash

source ./reper.conf
ulimit -v "$maxMemoryKB"


perl build_landscape.pl --clstr "$CLUSTEROUT".clstr --fasta "$CLASSIFYOUT" --bam "$QUANTOUT" --coverage "$COVERAGE" --samtools "$samtools"

if [ $? -eq 0 ]; then
    echo "########################"
    date
    echo "reper finished"
    echo "you can find the results in the repeat-landscape files."
else
    echo "########################"
    echo "landscape building failed"
    exit 1
fi



