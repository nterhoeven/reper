#!/bin/bash

source ./reper.conf
ulimit -v "$maxMemoryKB"

#blast vs database
"$blastn" -query "$CLUSTEROUT" -db "$classificationDB" -outfmt 7 -out "$CLUSTEROUT"_class.bls -num_threads "$MAXTHREADS" -task 'blastn'
"$blastn" -query "$CLUSTEROUT" -db "$chloroDB" -outfmt 7 -out "$CLUSTEROUT"_chloro.bls -num_threads "$MAXTHREADS" -task 'blastn'
"$blastn" -query "$CLUSTEROUT" -db "$mitoDB" -outfmt 7 -out "$CLUSTEROUT"_mito.bls -num_threads "$MAXTHREADS" -task 'blastn'

#analyse blast results

perl "$scrDir"/classification_blast-parser.pl "$CLUSTEROUT" "$CLASSIFYOUT" "$CLUSTEROUT"_class.bls "$CLUSTEROUT"_chloro.bls "$CLUSTEROUT"_mito.bls

echo "###################################"
echo "finished classification -running quantification"
"$reperDir"/reper quantify
