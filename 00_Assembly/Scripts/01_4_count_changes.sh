#!/bin/bash

echo -e "Species\tAll\tInsertions\tDeletions\tSNPs"

## Count PEPPER changes
for i in *.vcf
do
        all=$(grep -v "#" $i | wc -l)
        snp=$(grep -v "#" $i | awk -F '[;[:blank:]]+' '{if (length($4)==length($5)) print $1,$4,$5}'| wc -l)
        del=$(grep -v "#" $i | awk -F '[;[:blank:]]+' '{if (length($4)>length($5)) print $1,$4,$5}'| wc -l)
        ins=$(grep -v "#" $i | awk -F '[;[:blank:]]+' '{if (length($4)<length($5)) print $1,$4,$5}'| wc -l)
        echo -e "${i}\t${all}\t${ins}\t${del}\t${snp}"
done

## Count Pilon changes after each round

for i in *_pilon1/pilon.changes
do
        all=$(wc -l $i | awk '{print $1}')
        snp=$(awk -F ' ' '{if ($3 != "." && $4 != ".") print $3,$4}' $i | wc -l)
        del=$(awk -F ' ' '{if ($3 != "." && $4 == ".") print $3,$4}' $i | wc -l)
        ins=$(awk -F ' ' '{if ($3 == "." && $4 != ".") print $3,$4}' $i | wc -l)
        echo -e "${i}\t${all}\t${ins}\t${del}\t${snp}"
done

for i in *_pilon2/pilon.changes
do
        all=$(wc -l $i | awk '{print $1}')
        snp=$(awk -F ' ' '{if ($3 != "." && $4 != ".") print $3,$4}' $i | wc -l)
        del=$(awk -F ' ' '{if ($3 != "." && $4 == ".") print $3,$4}' $i | wc -l)
        ins=$(awk -F ' ' '{if ($3 == "." && $4 != ".") print $3,$4}' $i | wc -l)
        echo -e "${i}\t${all}\t${ins}\t${del}\t${snp}"
done

for i in *_pilon3/pilon.changes
do
        all=$(wc -l $i | awk '{print $1}')
        snp=$(awk -F ' ' '{if ($3 != "." && $4 != ".") print $3,$4}' $i | wc -l)
        del=$(awk -F ' ' '{if ($3 != "." && $4 == ".") print $3,$4}' $i | wc -l)
        ins=$(awk -F ' ' '{if ($3 == "." && $4 != ".") print $3,$4}' $i | wc -l)
        echo -e "${i}\t${all}\t${ins}\t${del}\t${snp}"
done
