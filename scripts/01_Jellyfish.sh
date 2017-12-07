#!/bin/bash

#read config - needed for paths
source ./reper.conf
ulimit -v "$maxMemoryKB"

echo "#########################################"
echo "using the following values for Jellyfish:"
echo "Jellyfish: $jellyfish"
echo "kmersize: $KMERSIZE"
echo "num-threads: $MAXTHREADS"
echo "outfile: $JELLYOUT"
echo "reads-1: $READS1"
echo "reads-2: $READS2"
echo "#########################################"

"$jellyfish" count -s 100000000 -C -m "$KMERSIZE" -t "$MAXTHREADS" -o "$JELLYOUT" "$READS1" "$READS2"


echo "############"
echo "finsished Jellyfish -> running kmer filter"
"$reperDir"/reper kmerFilter
