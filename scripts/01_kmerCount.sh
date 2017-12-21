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

if [ $? -eq 0 ]; then
    "$reperDir"/reper kmerFilter
else
    echo "########################"
    echo "kmerCount failed"
    exit 1
fi

