#!/bin/bash

#Round 1 pilon
for flyline in "A28" "MS" "O11" "D_equinoxialis" "D_insularis" "D_paulistorum_L06" "D_paulistorum_L1
2" "D_sp" "D_sucinea" "D_tropicalis" "D_willistoni_00" "D_willistoni_LG3"
do
        assembly="./${flyline}_pepper_cor.fasta"
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
        #/space/Software/bwa/bwa index $assembly

        echo "mapping illumina reads"
        #Map Illumina reads to the pepper-polished assembly
        #/space/Software/bwa/bwa mem -t 20 $assembly $illumina1 $illumina2 | samtools view -bSu - |
samtools sort -@ 20 -o ${flyline}_map1.bam

        #Index BAM files
        samtools index ${flyline}_map1.bam

        echo "Running Pilon"
        java -Xmx120G -jar /space/Software/pilon/pilon-1.24.jar --genome $assembly --bam ${flyline}_
map1.bam --outdir ${flyline}_pilon1 \
                --changes --tracks --fix "indels" --mindepth 10
done

#ln files
for flyline in "A28" "MS" "O11" "D_equinoxialis" "D_insularis" "D_paulistorum_L06" "D_paulistorum_L1
2" "D_sp" "D_sucinea" "D_tropicalis" "D_willistoni_00" "D_willistoni_LG3"
do
        assembly_path="/space/no_backup/merce/polish/${flyline}_pilon1/pilon.fasta"

        ln -s -f ${assembly_path} /space/no_backup/merce/paulistorum/${flyline}_pilon1.fasta
        ln -s -f ${assembly_path} /space/no_backup/merce/polish/${flyline}_pilon1.fasta
done

#Clean up folders to not occupy that much space
rm ./*_pilon1/*.wig


#Round 2 pilon
for flyline in "A28" "MS" "O11" "D_equinoxialis" "D_insularis" "D_paulistorum_L06" "D_paulistorum_L1
2" "D_sp" "D_sucinea" "D_tropicalis" "D_willistoni_00" "D_willistoni_LG3"
do
        assembly="./${flyline}_pilon1.fasta"
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
        /space/Software/bwa/bwa mem -t 20 $assembly $illumina1 $illumina2 | samtools view -bSu - | samtools sort -@ 20 -o ${flyline}_map2.bam

        #Index BAM files
        samtools index ${flyline}_map2.bam

        echo "Running Pilon"
        java -Xmx120G -jar /space/Software/pilon/pilon-1.24.jar --genome $assembly --bam ${flyline}_map2.bam --outdir ${flyline}_pilon2 \
                --changes --tracks --fix "indels" --mindepth 10
done

#ln files
for flyline in "A28" "MS" "O11" "D_equinoxialis" "D_insularis" "D_paulistorum_L06" "D_paulistorum_L12" "D_sp" "D_sucinea" "D_tropicalis" "D_willistoni_00" "D_willistoni_LG3"
do
        assembly_path="/space/no_backup/merce/polish/${flyline}_pilon2/pilon.fasta"

        ln -s -f ${assembly_path} /space/no_backup/merce/paulistorum/${flyline}_pilon2.fasta
        ln -s -f ${assembly_path} /space/no_backup/merce/polish/${flyline}_pilon2.fasta
done

#Clean up folders to not occupy that much space
rm ./*_pilon2/*.wig

#Round 3 pilon
for flyline in "A28" "MS" "O11" "D_equinoxialis" "D_insularis" "D_paulistorum_L06" "D_paulistorum_L12" "D_sp" "D_sucinea" "D_tropicalis" "D_willistoni_00" "D_willistoni_LG3"
do
        assembly="./${flyline}_pilon2.fasta"
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
        /space/Software/bwa/bwa mem -t 20 $assembly $illumina1 $illumina2 | samtools view -bSu - | samtools sort -@ 20 -o ${flyline}_map3.bam

        #Index BAM files
        samtools index ${flyline}_map3.bam

        echo "Running Pilon"
        java -Xmx120G -jar /space/Software/pilon/pilon-1.24.jar --genome $assembly --bam ${flyline}_map3.bam --outdir ${flyline}_pilon3 \
                --changes --tracks --fix "indels" --mindepth 10
done

#ln files
for flyline in "A28" "MS" "O11" "D_equinoxialis" "D_insularis" "D_paulistorum_L06" "D_paulistorum_L12" "D_sp" "D_sucinea" "D_tropicalis" "D_willistoni_00" "D_willistoni_LG3"
do
        assembly_path="/space/no_backup/merce/polish/${flyline}_pilon3/pilon.fasta"

        ln -s -f ${assembly_path} /space/no_backup/merce/paulistorum/${flyline}_pilon3.fasta
        ln -s -f ${assembly_path} /space/no_backup/merce/polish/${flyline}_pilon3.fasta
done

#Clean up folders to not occupy that much space
rm ./*_pilon3/*.wig
