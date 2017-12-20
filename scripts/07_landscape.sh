#!/bin/bash

source ./reper.conf
ulimit -v "$maxMemoryKB"


perl "$scrDir"/build_landscape.pl --clstr "$CLUSTEROUT".clstr --fasta "$CLASSIFYOUT" --bam "$QUANTOUT" --coverage "$COVERAGE" --samtools "$samtools"

if [ $? -eq 0 ]; then
    if [ $cleanUp -eq "yes" ]; then
	echo "########################"
	date
	echo "cleaning up intermediate files"

	rm Trinity.fasta
	cp trinity_out_dir/Trinity.fasta .
	rm "$JELLYOUT" "$FILTEROUT"*.fq "$QUANTOUT"* *.bls *.bt2
	rm -r trinity_out_dir
    fi
    
    echo "########################"
    date
    echo "reper finished"
    echo "you can find the results in the repeat-landscape files."
else
    echo "########################"
    echo "landscape building failed"
    exit 1
fi



