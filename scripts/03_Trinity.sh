#!/bin/bash

source reper.conf

IN1="$FILTEROUT"_1.fq
IN2="$FILTEROUT"_2.fq

"$trinity" --seqType fq --JM "$MAXMEMORY" --left "$IN1" --right "$IN2"  --CPU "$MAXTHREADS"

echo "################################"
echo "assembly finished --> run cd-hit"
ln -s ./trinity_out_dir/Trinity.fasta                                                                                                                        
"$reperDir"/reper cluster
