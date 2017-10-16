FROM Ubuntu:16.04

RUN apt update && apt -y dist-upgrade

ENV reperDir /reper
RUN mkdir $reperDir && cd $reperDir && wget https://github.com/nterhoeven/reper/archive/master.zip && unzip master.zip

RUN mkdir dependencies && cd dependencies && wget https://github.com/gmarcais/Jellyfish/releases/download/v2.2.6/jellyfish-2.2.6.tar.gz && tar xzf jellyfish-2.2.6.tar.gz && cd jellyfish-2.2.6 && ./configure && make && make install
RUN cd $reperDir/dependencies wget https://github.com/trinityrnaseq/trinityrnaseq/archive/Trinity-v2.4.0.tar.gz && tar xzf Trinity-v2.4.0.tar.gz
RUN cd $reperDir/dependencies wget https://github.com/weizhongli/cdhit/releases/download/V4.6.7/cd-hit-v4.6.7-2017-0501-Linux-binary.tar.gz && tar xzf cd-hit-v4.6.7-2017-0501-Linux-binary.tar.gz
RUN cd $reperDir/dependencies && wget https://github.com/BenLangmead/bowtie2/releases/download/v2.3.2/bowtie2-2.3.2-linux-x86_64.zip && unzip bowtie2-2.3.2-linux-x86_64.zip
RUN cd $reperDir/dependencies && wget https://github.com/samtools/samtools/releases/download/1.4.1/samtools-1.4.1.tar.bz2 && tar xjf samtools-1.4.1.tar.bz2 && cd samtools-1.4.1 && ./configure && make && make install
RUN cd $reperDir/dependencies && wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.28/ncbi-blast-2.2.28+-x64-linux.tar.gz && tar xzf ncbi-blast-2.2.28+-x64-linux.tar.gz

CMD $reperDir/reper
