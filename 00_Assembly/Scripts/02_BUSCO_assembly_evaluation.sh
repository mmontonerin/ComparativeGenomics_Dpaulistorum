#!/bin/bash

#activate busco environment first
#conda activate /space/Software/busco_conda

for i in ./*fasta
do
        j=$(basename "$i" .fasta)
        busco -i $i -o "$j"_busco -l diptera_odb10 -m genome -f --augustus_species fly
done
