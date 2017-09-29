# reper
reper - A kmer based repeat detection pipeline

## What is reper?
reper is a pipeline to detect repetitive sequences in genome sequencing data.
The detection is based on kmer frequencies and does not rely on a genome assembly.
This allows an analysis of repeat sequences of organisms with large and repeat rich
genomes (especially plants). 

## Installation
### Dependencies
reper depends on a few other software packages (see list below). Most of them are common
bioinformatic tools and probably already installed on your system. If this is not the case,
reper ships with a script called `install_dependencies.sh` which downloads and installs all
necessary software in a subdirectory of reper.

The example config file `reper.conf` contains the locations of the dependencies used by the
install-script. If you want to use already installed software, you have to change the paths
in the config file.

#### List of dependencies

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

### Running the Pipeline
The reper pipeline consists of 8 steps - kmer counting, read filtering, assembly, clustering, classification, quantification and landscape construction.
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

The first section has to be adjusted to each run. The second section has to be adjusted if you use
instances of the dependencies which are not installed by reper. You rarely have to change the third section,
as it contains settings used internally in reper.

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