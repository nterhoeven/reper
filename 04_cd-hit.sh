#!/bin/bash

source repeat_pipeline.cfg

#cluster sequences with identity>0.8 and length>0.9; 32 CPUs 10GB Memory limit

"$cdHit" -i "$TRINITYOUT" -o "$CLUSTEROUT" -c 0.8 -n 5 -G 0 -aS 0.9 -T "$MAXTHREADS" -M 10000


echo "#############################################"
echo "exemplar building finished --> run classifier"
./00_run_repeat_pipeline.sh classify
