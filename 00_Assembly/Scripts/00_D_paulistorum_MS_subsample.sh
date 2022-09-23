#!/bin/bash

#Downsample to 40X, with length of read as a priority, and using the assembly with all the reads as reference

/space/Software/Filtlong/bin/filtlong --target_bases 10000000000 --min_length 1000 --length_weight 10 -a MS_nextdenovo_assembly.fasta MS_pass_concat.fastq | gzip > MS_assembly_length_filtered_40X.fastq.gz
