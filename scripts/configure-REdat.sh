#!/bin/bash

source ./reper.conf
ulimit -v "$maxMemoryKB"

mkdir -p "$dbDir"/REdat
cd "$dbDir"/REdat

echo "Downloading REdat repeat database from ftp://ftpmips.helmholtz-muenchen.de/plants/REdat/mipsREdat_9.3p_ALL.fasta.gz"
wget ftp://ftpmips.helmholtz-muenchen.de/plants/REdat/mipsREdat_9.3p_ALL.fasta.gz
echo "finished downloading - extracting files"
gunzip mipsREdat_9.3p_ALL.fasta.gz
echo "formatting fasta file"
perl -i -ne 'if($_=~/^>/){chomp;@head=split(/\|/,$_); print join("|", $head[0],$head[2],$head[5]),"\n"}else{print uc($_)}' mipsREdat_9.3p_ALL.fasta

echo "creating blast DB"
"$makeblastdb" -dbtype 'nucl' -in mipsREdat_9.3p_ALL.fasta
