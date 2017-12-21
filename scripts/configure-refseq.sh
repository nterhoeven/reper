#!/bin/bash

source ./reper.conf
ulimit -v "$maxMemoryKB"

mkdir -p "$dbDir"/refseq
cd "$dbDir"/refseq

echo "Downloading mitochondrion data from ftp://ftp.ncbi.nlm.nih.gov/refseq/release/mitochondrion/"
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/mitochondrion/mitochondrion.1.1.genomic.fna.gz
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/mitochondrion/mitochondrion.2.1.genomic.fna.gz

gunzip mitochondrion.1.1.genomic.fna.gz
gunzip mitochondrion.2.1.genomic.fna.gz

echo "Downloading chloroplast data from ftp://ftp.ncbi.nlm.nih.gov/refseq/release/plastid/"
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/plastid/plastid.1.1.genomic.fna.gz
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/plastid/plastid.2.1.genomic.fna.gz

gunzip plastid.1.1.genomic.fna.gz
gunzip plastid.2.1.genomic.fna.gz 

echo "formatting fasta files"

perl -ne 'if($_=~/^>/){($id,$species,$mito)=$_=~/(>NC\S+) (.+) (mitochondrion),/; $species=~s/ /-/g; print join("|", $id,$mito,$species),"\n"}else{print uc($_)}' mitochondrion.1.1.genomic.fna mitochondrion.2.1.genomic.fna > refseq-mito.fa

perl -ne 'if($_=~/^>/){($id,$species,$chlo)=$_=~/(>NC\S+) (.+) (chloroplast),/; $species=~s/ /-/g; print join("|", $id,$chlo,$species),"\n"}else{print uc($_)}' plastid.1.1.genomic.fna plastid.2.1.genomic.fna > refseq-chloro.fa


echo "creating blast DBs"
"$makeblastdb" -dbtype 'nucl' -in refseq-mito.fa
"$makeblastdb" -dbtype 'nucl' -in refseq-chloro.fa


