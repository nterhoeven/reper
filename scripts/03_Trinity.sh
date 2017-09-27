#!/bin/bash

source repeat_pipeline.cfg

IN1=$1
IN2=$2

"$trinity" --seqType fq --JM "$MAXMEMORY" --left "$IN1" --right "$IN2"  --CPU "$MAXTHREADS"

echo "################################"
echo "assembly finished --> run cd-hit"
ln -s ./trinity_out_dir/Trinity.fasta                                                                                                                        
./00_run_repeat_pipeline.sh cluster
