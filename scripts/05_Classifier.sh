#!/bin/bash

source reper.conf
ulimit -v "$maxMemoryKB"
#blast vs database

#filter vs chloro and mito


echo "###################################"
echo "finished classification -running quantification"
echo "running filtering against chloroplast and mitochondrion"
"$reperDir"/reper quantify
