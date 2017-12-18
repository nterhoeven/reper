#!/bin/bash

source ./reper.conf
ulimit -v "$maxMemoryKB"


perl build_landscape.pl --clstr "$CLUSTEROUT".clstr --fasta "$CLASSIFYOUT" --bam "$QUANTOUT" --coverage "$COVERAGE" --samtools "$samtools"

Rscript plot-landscape.R

###########

echo "#####################"
date
echo "reper finished"
echo "you can find the results in the repeat-landscape files."
