#!/bin/bash

#read config for parameters
source ./reper.conf
ulimit -v "$maxMemoryKB"

#kmer-filter script needs jellyfish in $PATH
jellypath=$(echo "$jellyfish" | sed -re 's@(.*/).*$@\1@g')
export PATH="$jellypath":$PATH

"$KmerFilter" --both -l "$CUTOFF" -u 0 --cutoff 50% -o "$FILTEROUT" -m "$KMERSIZE" -k "$JELLYOUT" --reads "$READS1" --mates "$READS2"


if [ $? -eq 0 ]; then
    "$reperDir"/reper assembly
else
    echo "########################"
    echo "kmerFilter failed"
    exit 1
fi

