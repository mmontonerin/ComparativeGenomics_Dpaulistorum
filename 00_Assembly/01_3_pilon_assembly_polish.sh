#!/bin/bash

for flyline in "MS" "O11" A28" "D_insularis" "D_paulistorum_L06" "D_paulistorum_L12" "D_sp" "D_sucinea" "D_tropicalis" "D_willistoni_00" "D_willistoni_LG3"
do
        assembly="./${flyline}_pepper_cor.fasta"
        
	#D.paulistorum L12 lacks Illumina data, so we used the closest semi-species data, D.paulistorum MS
	if ${flyline} =~ "D_paulistorum_L12"
        then
                illumina1="D_paulistorum_MS_R1.fastq.gz"
                illumina2="D_paulistorum_MS_R2.fastq.gz"
        else
        illumina1="${flyline}_illumina_R1.fastq.gz"
        illumina2="${flyline}_illumina_R2.fastq.gz"
        fi
	
	#Check that it is running the right assembly with the right reads
        echo "Running:"
	echo "$assembly"
        echo "$illumina1"
        echo "$illumina2"

        #Index assembly
        /space/Software/bwa/bwa index $assembly

        #Map Illumina reads to the pepper-polished assembly
        /space/Software/bwa/bwa mem -t 20 $assembly $illumina1 $illumina2 | samtools view -bSu - | samtools sort -@ 20 -o ${flyline}_map.bam

        #Index BAM files
        samtools index ${flyline}_map.bam

        java -Xmx120G -jar /space/Software/pilon/pilon-1.24.jar --genome $assembly --bam ${flyline}_map.bam --outdir ${flyline}_pilon \
                --changes --tracks --vcf --fix "indels" --mindepth 10
        


done
