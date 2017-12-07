#!/bin/bash

source ./reper.conf

$maxMemoryMB=$(echo "$maxMemoryKB/1000" | bc)
#cluster sequences with identity>0.8 and length>0.9; 32 CPUs 10GB Memory limit; -d 0 disables the sequence name cutoff

"$cdHit" -i "$TRINITYOUT" -o "$CLUSTEROUT" -d 0 -c 0.8 -n 5 -G 0 -aS 0.9 -T "$MAXTHREADS" -M "$maxMemoryMB"


echo "#############################################"
echo "exemplar building finished --> run classifier"
"$reperDir"/reper classify
