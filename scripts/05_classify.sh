#!/bin/bash

source ./reper.conf
ulimit -v "$maxMemoryKB"

#blast vs database
"$blastn" -query "$CLUSTEROUT" -db "$classificationDB" -outfmt 7 -out "$CLUSTEROUT"_class.bls -num_threads "$MAXTHREADS" -task 'blastn'
if [ $? -ne 0 ]; then
    echo "########################"
    echo "blast vs $classificationDB failed"
    exit 1
fi

"$blastn" -query "$CLUSTEROUT" -db "$chloroDB" -outfmt 7 -out "$CLUSTEROUT"_chloro.bls -num_threads "$MAXTHREADS" -task 'blastn'
if [ $? -ne 0 ]; then
    echo "########################"
    echo "blast vs $chloroDB failed"
    exit 1
fi

"$blastn" -query "$CLUSTEROUT" -db "$mitoDB" -outfmt 7 -out "$CLUSTEROUT"_mito.bls -num_threads "$MAXTHREADS" -task 'blastn'
if [ $? -ne 0 ]; then
    echo "########################"
    echo "blast vs $mitoDB failed"
    exit 1
fi


#analyse blast results
perl "$scrDir"/classification_blast-parser.pl "$CLUSTEROUT" "$CLASSIFYOUT" "$CLUSTEROUT"_class.bls "$CLUSTEROUT"_chloro.bls "$CLUSTEROUT"_mito.bls

if [ $? -eq 0 ]; then
    "$reperDir"/reper quantify
else
    echo "########################"
    echo "classification failed"
    exit 1
fi
