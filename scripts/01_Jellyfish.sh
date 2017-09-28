#!/bin/bash

#read config - needed for paths
source reper.conf
ulimit -v "$maxMemoryKB"

"$jellyfish" count -s 100000000 -C -m "$KMERSIZE" -t "$MAXTHREADS" -o "$JELLYOUT" "$READS1" "$READS2"


echo "############"
echo "finsished Jellyfish -> running kmer filter"
"$reperDir"/reper kmerFilter
