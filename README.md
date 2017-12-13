# reper
reper - A kmer based repeat detection pipeline

## What is reper?
reper is a pipeline to detect repetitive sequences in genome sequencing data.
The detection is based on kmer frequencies and does not rely on a genome assembly.
This allows an analysis of repeat sequences of organisms with large and repeat rich
genomes (especially plants). 


## tl,dr
I don't want to read much - just let me start.

Download and install reper via Docker

```
docker pull ########
```

configure databases

```
docker run reper reper configure-REdat
docker run reper reper configure-refseq
```

run pipeline with test dataset (runs on XX CPU cores with XXG memory)

```
unzip testdata.zip
docker run reper reper jelly
```



## Installation

### Docker
To make installation easy and ensure reproducibility, we provide a Docker container
for reper with all dependencies installed.

### Singularity

### Manual installation
reper can be installed manually on your system. In order to do so, please install the
dependencies listed below, download this github repository and add the correct paths
in the reper.conf file.

### List of dependencies

| Tool | version | license | citation |
| --- | --- | --- | --- |
| Jellyfish  | 2.2.6 | GPl-3.0 | [1] |
| Trinity | 2.4.0 | BSD 3-clause | [2] |
| cd-hit | 4.6.7 | GPL-2.0 | [3], [4] |
| Bowtie | 2.3.2 | Artistic | [5] |
| samtools | 1.4.1 | MIT | [6] |
| blast+ | 2.2.28 | Public Domain | [7], [8] |
| kmer-filter| | | |
| PGSB-REdat | | | [9] |


## Usage

### preparing the databases

For the classification of the found repeats, reper needs a library of
known repeats. This can be any user defined repeat set as long as the file
format fits the needs of reper (see below). There are automated scripts included
to configure the databases REdat, repbase and refseq (for chloroplast and mitochondrion).

If you are working with plant data, we recommend to use REdat for the repeat classification
and refseq for the identification of chloroplast and mitochondrion. You can download and
configure these databases with the following commands:

```
reper configure-REdat
reper configure-refseq
```

If you want to use the repbase database, you have to obtain it from the giri-website yourself
and accept their license terms. You can then use `reper configure-repbase` to create a reper-compatible
file from it.

The database file should be in fasta format with header like this:
```
>seqID|class|source
```
The seqID should contain a unique ID, the class the class assigned to this sequence
and the source can be a species name or similar



### Running the Pipeline
The reper pipeline consists of 7 steps - kmer counting, read filtering, assembly, clustering, classification, quantification and landscape construction.
To start reper, use

```
reper <jobname>
```

reper will then run the pipeline beginning from the specified job. There are no further arguments required, since
all information reper needs is specified in the config file `reper.conf`.

### The config file

The config file is called `reper.conf` and consists of the following sections

- run-specific data
  + sequencing library names
  + seqencing depth
  + average read length
  + output directory
  + CPU and Memory limits
- Dependencies
  + paths to required software and databases
- Step specific options
  + names of intermediate files
  + parameter settings shared between steps

The first section has to be adjusted to each run. The second section has to be adjusted if you
installed reper manually and did not use the docker or singularity image. You rarely have to change
the third section, as it contains settings used internally in reper.

## References

[1] Guillaume Marcais and Carl Kingsford, A fast, lock-free approach for efficient parallel counting of occurrences of k-mers. Bioinformatics (2011) 27(6): 764-770 (first published online January 7, 2011) doi:10.1093/bioinformatics/btr011
[2] Grabherr MG, Haas BJ, Yassour M, et al. Trinity: reconstructing a full-length transcriptome without a genome from RNA-Seq data. Nature biotechnology. 2011;29(7):644-652. doi:10.1038/nbt.1883.
[3] "Cd-hit: a fast program for clustering and comparing large sets of protein or nucleotide sequences", Weizhong Li & Adam Godzik Bioinformatics, (2006) 22:1658-9
[4] Limin Fu, Beifang Niu, Zhengwei Zhu, Sitao Wu and Weizhong Li, CD-HIT: accelerated for clustering the next generation sequencing data. Bioinformatics, (2012), 28 (23): 3150-3152. doi: 10.1093/bioinformatics/bts565
[5] Langmead B, Trapnell C, Pop M, Salzberg SL. Ultrafast and memory-efficient alignment of short DNA sequences to the human genome. Genome Biol 10:R25.
[6] Li H, Mathematical Notes on SAMtools Algorithms
[7] Altschul, S.F., Gish, W., Miller, W., Myers, E.W. & Lipman, D.J. (1990) "Basic local alignment search tool." J. Mol. Biol. 215:403-410.
[8] Camacho C., Coulouris G., Avagyan V., Ma N., Papadopoulos J., Bealer K., & Madden T.L. (2008) "BLAST+: architecture and applications." BMC Bioinformatics 10:421.
[9] Nussbaumer T, Martis MM, Roessner SK, Pfeifer M, Bader KC, Sharma S, Gundlach H, Spannagl M. MIPS PlantsDB: a database framework for comparative plant genome research. Nucleic Acids Res. 2013 Jan;41(Database issue):D1144-51.