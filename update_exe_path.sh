#!/bin/bash

sed -i '/^jellyfish=/   s#^\(jellyfish=\).*#\1'"$(which jellyfish)"'#;
        /^trinity=/     s#^\(trinity=\).*#\1'"$(which Trinity)"'#;
        /^cdHit=/       s#^\(cdHit=\).*#\1'"$(which cd-hit-est)"'#;
        /^bowtieBuild=/ s#^\(bowtieBuild=\).*#\1'"$(which bowtie2-build)"'#;
        /^bowtie2=/     s#^\(bowtie2=\).*#\1'"$(which bowtie2)"'#;
        /^samtools=/    s#^\(samtools=\).*#\1'"$(which samtools)"'#;
        /^makeblastdb=/ s#^\(makeblastdb=\).*#\1'"$(which makeblastdb)"'#;
        /^blastn=/      s#^\(blastn=\).*#\1'"$(which blastn)"'#;
        /^KmerFilter=/  s#^\(KmerFilter=\).*#\1'"$(which kmer-filter)"'#;' /reper/reper.conf
