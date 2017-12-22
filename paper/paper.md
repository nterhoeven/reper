---
title: 'reper: Genome-wide identification, classification and quantification of repetitive elements without an assembled genome'
tags:  
  - repeats
  - transposons
  - kmer
  - pipeline
  - repeat landscape
  - NGS
authors:
  - name: Niklas Terhoeven
    orcid: 0000-0002-8669-0000
    affiliation: "1, 2" # (Multiple affiliations must be quoted)
  - name: Jörg Schultz
    orcid:
    affiliation: "1, 2"
  - name: Thomas Hackl
    orcid: 0000-0002-0022-320X
    affiliation: 3
affiliations:
  - name: Center for Computational and Thoeretical Biology, Universität Würzburg
    index: 1
  - name: Lehrstuhl für Bioinformatik, Universität Würzburg
    index: 2
  - name: Department of Civil and Environmental Engineering, Massachusetts Institute of Technology
    index: 3
date: 07 December 2017
bibliography: paper.bib
---

# Summary

Repetitive elements constitute a substantial fraction of most eukaryotic genomes.
Still, their actual amount differs strongly between species. For example, the genome of *Saccharomyces cervisiae*
contains only about 3 % repeats ([@kim_transposable_1998]), *Arabidopsis* harbours 14 % ([@the_arabidopsis_genome_initiative_analysis_2000]),
human 50 % ([@lander_initial_2001]) and wheat even 90 % ([@clavijo_improved_2017]).

Annotation and Classification of these elements is a pivotal step in the annotation of each genome.
Furthermore, tracing their history can give ample insights into the evolution of a genome and thereby,
of a species. Accordingly, different methods for repeat annotation have been developed ([@smit_repeatmasker_2013], [@benson_tandem_1999], [@gymrek_lobstr:_2012]).
Still, typically they rely on an assembled genome sequence – a prerequisite which can lead to erroneous results.
As repetitive elements are highly similar assembly algorithms will collapse repeat variants into a single
occurrence or not assemble the repetitive regions at all. Thus, the annotation of repeat regions and thereby the
characterization of their content and diversity solely based on an assembled genome sequence can give misleading results.

To address this challenge, we developed reper, a kmer based method to detect, classify and quantify repeats
in next generation sequencing (NGS) data without the need of a genome assembly.
Our pipeline samples reads with high kmer coverage directly from the NGS dataset (kmer counts based on jellyfish [@marcais_fast_2011]). This subset is 
assembled using the transcriptome assembler Trinity ([@grabherr_full-length_2011]), allowing reper to recover repeat variants at a high resolution.
To create exemplar sequences of each repeat in the genome, the assembled repeats ar clustered using cd-hit ([@li_cd-hit:_2006],[@fu_cd-hit:_2012]).
These are further classified based on homology to known repeats using multiple blast ([@camacho_blast]) searches. Since reper was developed with
a focus on plant data, the default classification libraries are REdat ([@nussbaumer_mips_2012]) for repeats, and refseq ([@oleary_reference_2016]) for chloroplast and mitochondrial
sequences. The reference database, however, can easily be customized to the user's needs. A configuration script for
the popular, but proprietary database repbase is provided with the package as well.
Next, the repeat content is quantified on sequence, cluster and class level using read mappings (bowtie2 and samtools, [@langmead_fast_2012] and [@li_sequence_2009]).
Finally, the repeat landscape can be analyzed and graphically represented with the R script provided with the pipeline.
Currently, reper is specifically customized to work with paired-end Illumina data, but support of long-read technologies such as PacBio and Nanopore is in development.

To date, there is only a single software package with a similar functionality to reper, namely dnaPipeTE ([@goubert_novo_2015]).
Still, it relies on dependencies like RepeatMasker, which has to be installed independently as well as the proprietary repeat database repbase by giri.
Contrasting, The reper source code is available on [github](https://github.com/nterhoeven/reper) under the MIT license.
To further ease installation and usage, a Docker container with a complete reper installation is also provided.
Since reper is usually run in an HPC environment where users don't have root or Docker rights, we furthermore made a singularity image available which can be used with standard user permissions.

We are currently using reper to analyze the repeat content in different plant genome sequencing projects.
An example using *Beta vulgaris* data is given in the tutorial section of the [reper wiki](https://github.com/nterhoeven/reper/wiki).


![schematic overview of workflow](workflow.png)


# Acknowledgements

We would like to thank Markus Ankenbrand and Frank Förster for valuable discussions and their support and advice on different topics like Docker and pipeline design.


# References
