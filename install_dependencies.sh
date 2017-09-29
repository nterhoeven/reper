#!/bin/bash

## List of dependency tools that will be installed
# - jellyfish
# - trinity
# - cd-hit
# - Bowtie2
# - samtools
# - blastn
# - Thomas KmerFilter script
# - databases for classification
#####################################################

reperDir=$(pwd)
dep="$reperDir/dep"

mkdir "$dep"
cd "$dep"

## Jellyfish
echo "Installing Jellyfish Version 2.2.6"
mkdir jellyfish
cd jellyfish

wget https://github.com/gmarcais/Jellyfish/releases/download/v2.2.6/jellyfish-2.2.6.tar.gz

tar xzf jellyfish-2.2.6.tar.gz
cd jellyfish-2.2.6
./configure --prefix=$(pwd)
make
make install

cd "$dep"

## Trinity
echo "Installing Trinity Version 2.4.0"

mkdir trinity
cd trinity

wget https://github.com/trinityrnaseq/trinityrnaseq/archive/Trinity-v2.4.0.tar.gz

tar xzf Trinity-v2.4.0.tar.gz
cd trinityrnaseq-Trinity-v2.4.0

cd "$dep"

## cd-hit
echo "Installing cd-hit Version 4.6.7"

mkdir cd-hit
cd cd-hit

wget https://github.com/weizhongli/cdhit/releases/download/V4.6.7/cd-hit-v4.6.7-2017-0501-Linux-binary.tar.gz

tar xzf cd-hit-v4.6.7-2017-0501-Linux-binary.tar.gz

cd "$dep"

## Bowtie2
echo "Installing Bowtie2 Version 2.3.2"

mkdir bowtie2
cd bowtie2

wget https://github.com/BenLangmead/bowtie2/releases/download/v2.3.2/bowtie2-2.3.2-linux-x86_64.zip
unzip bowtie2-2.3.2-linux-x86_64.zip

cd "$dep"

## samtools
echo "Installing samtools Version 1.4.1"

mkdir samtools
cd samtools

wget https://github.com/samtools/samtools/releases/download/1.4.1/samtools-1.4.1.tar.bz2
tar xjf samtools-1.4.1.tar.bz2

# #remove conflicting dependency lzma.h
# cd samtools-1.4.1/htslib-1.4.1/
# make distclean
# ./configure --disable-lzma
# make
# cd ..
# make distclean
# #install samtools
# make
# make prefix=$(pwd) install


## from readme
#./configure --enable-plugins --enable-libcurl --without-curses --disable-lzma --with-plugin-path=$PWD/htslib-1.4.1
# fixed version - disabled some features
./configure --enable-plugins --enable-libcurl --without-curses --disable-bz2 --disable-lzma --disable-libcurl --with-plugin-path=$PWD/htslib-1.4
make all plugins-htslib
make prefix=$(pwd) install

cd "$dep"

## blast
echo "Installing blast+ Version 2.2.28"

mkdir blast
cd blast

wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.28/ncbi-blast-2.2.28+-x64-linux.tar.gz
tar xzf ncbi-blast-2.2.28+-x64-linux.tar.gz

cd "$dep"

## kmer filter
echo "Installing kmer-filter"

mkdir kmer-filter
cd kmer-filter

wget https://github.com/thackl/kmer-scripts/archive/master.zip
unzip master.zip

mkdir perl-modules
cd perl-modules
wget http://search.cpan.org/CPAN/authors/id/M/MS/MSCHILLI/Log-Log4perl-1.49.tar.gz
tar xzf Log-Log4perl-1.49.tar.gz
cd Log-Log4perl-1.49/
perl Makefile.PL
make
make test
export PERL5LIB="$dep/kmer-filter/perl-modules/Log-Log4perl-1.49/lib":$PERL5LIB
