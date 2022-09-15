#!/bin/bash

#Downsample with length as a priority, to reach 40X coverage

/space/Software/Filtlong/bin/filtlong --target_bases 10000000000 --min_length 1000 --length_weight 10 O11_pass_concat.fastq | gzip > O11_length_filtered_40X.fastq.gz
