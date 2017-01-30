#!/bin/bash

#read config - needed for paths
source repeat_pipeline.cfg

"$jellyfish" count -s 100000000 -C -m "$KMERSIZE" -t "$MAXTHREADS" -o "$JELLYOUT" "$READS1" "$READS2"


echo "############"
echo "finsished Jellyfish -> running kmer filter"
./00_run_repeat_pipeline.sh kmerFilter
