#!/bin/bash

source "$reperDir"/reper.conf
ulimit -v "$maxMemoryKB"

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

perl -ne 'if($_=~/^>/){($id,$species,$mito)=$_=~/(>NC\S+) (.+) (mitochondrion),/; $species=~s/ /-/g; print join("|", $id,$mito,$species),"\n"}else{print uc($_)}' mitochondrion.1.1.genomic.fna.gz mitochondrion.2.1.genomic.fna.gz > refseq-mito.fa

perl -ne 'if($_=~/^>/){($id,$species,$chlo)=$_=~/(>NC\S+) (.+) (chloroplast),/; $species=~s/ /-/g; print join("|", $id,$chlo,$species),"\n"}else{print uc($_)}' plastid.1.1.genomic.fna plastid.2.1.genomic.fna > refseq-chloro.fa


