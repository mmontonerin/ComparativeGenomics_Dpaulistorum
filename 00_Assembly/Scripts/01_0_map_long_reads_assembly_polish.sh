#!/bin/bash

for i in ./*fasta

        do
                j=$(basename "$i" .fasta)
                k="$j"_nanopore.fastq.gz

                samtools faidx $i
                
                /space/Software/minimap2/minimap2 -ax map-ont $i $k -t 20 --secondary=no | samtools sort -o "$j"_sorted.bam

                samtools index "$j"_sorted.bam

done

