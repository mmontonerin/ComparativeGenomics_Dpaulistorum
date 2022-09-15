#!/bin/bash

#Downsample with quality of reads as priority, and to reach a 50X coverage

/space/Software/Filtlong/bin/filtlong --target_bases 12500000000 --min_length 1000 --mean_q_weight 10 O11_pass_concat.fastq | gzip > O11_Phred_filtered_50X.fastq.gz
