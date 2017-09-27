#!/bin/bash

source repeat_pipeline.cfg

# run blast
## chloro
"$blastn" -query "$CLUSTEROUT" -db "$CHLO" -evalue 1e-3 -num_threads "$MAXTHREADS" -outfmt 7 -out "$FILCHLOOUT"

##mito
"$blastn" -query "$CLUSTEROUT" -db "$MITO" -evalue 1e-3 -num_threads "$MAXTHREADS" -outfmt 7 -out "$FILMITOOUT"


# parse blast
## initialize list file
perl -e 'print join("\t","#Cluster","SeqID","reason"),"\n"' > special_seqs.list
## grep chloro matches from blast
grep -v '^#' "$FILCHLOOUT" | cut -f1 | sort | uniq > matched_chloro.list
## add chloroplast matches
cat Trinity.fasta.exemplars.clstr | perl -ne 'BEGIN{open(IN,"<matched_chloro.list")||die; while(<IN>){chomp;$list{$_}=1;}close IN||die} $clsID=$1 if $_=~/^>Cluster\s+(\d+)/; ($seq)=$_=~/>(c\d+\S+)\.{3}/; print join("\t",$clsID,$seq,"Chloroplast"),"\n" if exists($list{$seq})' >> special_seqs.list
## grep mito matches from blast
grep -v '^#' "$FILMITOOUT" | cut -f1 | sort | uniq > matched_mito.list
## add mito matches
cat Trinity.fasta.exemplars.clstr | perl -ne 'BEGIN{open(IN,"<matched_mito.list")||die;while(<IN>){chomp;$list{$_}=1;}close IN||die} $clsID=$1 if $_=~/^>Cluster\s+(\d+)/; ($seq)=$_=~/>(c\d+\S+)\.{3}/; print join("\t",$clsID,$seq,"Mitochondrion"),"\n" if exists($list{$seq})' >> special_seqs.list