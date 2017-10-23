#!/bin/bash

source reper.conf
ulimit -v "$maxMemoryKB"

#blast vs database
"$blastn" -query "$CLUSTEROUT" -db "$classificationDB" -outfmt 7 -out "$CLUSTEROUT"_class.bls -num_threads "MAXTHREADS" -task 'blastn'
"$blastn" -query "$CLUSTEROUT" -db "$chloroDB" -outfmt 7 -out "$CLUSTEROUT"_chloro.bls -num_threads "MAXTHREADS" -task 'blastn'
"$blastn" -query "$CLUSTEROUT" -db "$mitoDB" -outfmt 7 -out "$CLUSTEROUT"_mito.bls -num_threads "MAXTHREADS" -task 'blastn'

#analyse blast results


echo "###################################"
echo "finished classification -running quantification"
"$reperDir"/reper quantify
