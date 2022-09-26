#!/bin/bash

for flyline in "A28" "MS" "O11" "D_equinoxialis" "D_insularis" "D_paulistorum_L06" "D_paulistorum_L12" "D_sp" "D_sucinea" "D_tropicalis" "D_willistoni_00" "D_willistoni_LG3"
do
        assembly="./${flyline}_pepper_cor.fasta"

        #D_paulistorum_L12 does not have Illumina data, and thus we use the phylogenetically closest semi-species, MS:
        if ${flyline} =~ "D_paulistorum_L12"
        then
                illumina1="../paulistorum/MS_illumina_R1.fastq.gz"
                illumina2="../paulistorum/MS_illumina_R2.fastq.gz"
        else
        illumina1="../paulistorum/${flyline}_illumina_R1.fastq.gz"
        illumina2="../paulistorum/${flyline}_illumina_R2.fastq.gz"
        fi

        echo "Running:"
        echo "$assembly"
        echo "$illumina1"
        echo "$illumina2"

        echo "Indexing assembly"
        #Index assembly
        /space/Software/bwa/bwa index $assembly

        echo "mapping illumina reads"
        #Map Illumina reads to the pepper-polished assembly
        /space/Software/bwa/bwa mem -t 20 $assembly $illumina1 $illumina2 | samtools view -bSu - | samtools sort -@ 20 -o ${flyline}_map.bam

        #Index BAM files
        samtools index ${flyline}_map.bam

        echo "Running Pilon"
        java -Xmx120G -jar /space/Software/pilon/pilon-1.24.jar --genome $assembly --bam ${flyline}_map.bam --outdir ${flyline}_pilon \
                --changes --tracks --vcf --fix "indels" --mindepth 10



done
