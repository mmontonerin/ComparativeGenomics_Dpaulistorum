#!/bin/bash

#Filter VCFs (Differently depending on the data, DP20 or DP40)

#DP40 in all, except DP20 in:
###D_paulistorum_L12
###D_sucinea
###D_willistoni_00
###D_willistoni_LG3

#DP40, Q05, GQ20, VAF06
for flyline in "MS" "A28" "O11" "D_paulistorum_L06" "D_sp" "D_tropicalis"
do
        i=${flyline}.vcf.gz
        j=$(basename $i .vcf.gz)
        /space/Software/bcftools/bcftools view -i 'QUAL>=5 && FMT/DP>=40 && FMT/GQ>=20 && FMT/VAF>=0.6' $i -o "$j"_filtered_Q05_DP40_GQ20_VAF_06.vcf --threads 5
done

#DP20, Q05, GQ20, VAF06
for flyline in "D_insularis" "D_paulistorum_L12" "D_sucinea" "D_willistoni_00" "D_willistoni_LG3"
do
        i=${flyline}.vcf.gz
        j=$(basename $i .vcf.gz)
        /space/Software/bcftools/bcftools view -i 'QUAL>=5 && FMT/DP>=20 && FMT/GQ>=20 && FMT/VAF>=0.6' $i -o "$j"_filtered_Q05_DP20_GQ20_VAF_06.vcf --threads 5
done

#Gzip all new VCFs
for i in *filtered_Q*.vcf
do
        /space/Software/bcftools/bcftools view $i -Oz -o "$i".gz
done

#Index new VCFs
for i in *filtered_Q*.vcf.gz
do
        /space/Software/bcftools/bcftools index $i
done


#Correct FASTA file
for flyline in "MS" "A28" "O11" "D_insularis" "D_paulistorum_L06" "D_paulistorum_L12" "D_sp" "D_sucinea" "D_tropicalis" "D_willistoni_00" "D_willistoni_LG3"
do
        filter_vcf=$(find ./ -name "${flyline}_filtered*.vcf.gz" -type f)
        assembly="../paulistorum/${flyline}_nextdenovo.fasta"

        echo "Correcting assembly:"
        echo $assembly
        echo "with VCF:"
        echo $filter_vcf
        cat $assembly | /space/Software/bcftools/bcftools consensus $filter_vcf > ${flyline}_pepper_cor.fasta
done
