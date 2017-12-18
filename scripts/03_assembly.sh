#!/bin/bash

source ./reper.conf

bowtiePath=$(echo "$bowtie2" | sed -e 's@/bowtie2$@@g')

export PATH="$bowtiePath":$PATH

IN1="$FILTEROUT"_1.fq
IN2="$FILTEROUT"_2.fq

"$trinity" --seqType fq --max_memory "$MAXMEMORY" --left "$IN1" --right "$IN2"  --CPU "$MAXTHREADS"

#header renaming -> needed since blast has issues with the long path info
perl -i -pne '$_=~s/(>\S+).*/$1/g' ./trinity_out_dir/Trinity.fasta


echo "################################"
echo "assembly finished --> run cd-hit"
ln -s ./trinity_out_dir/Trinity.fasta
"$reperDir"/reper cluster
