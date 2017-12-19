#!/bin/bash

fastq-dump --defline-seq '@$sn[_$rn]/$ri' --split-files SRR952972
