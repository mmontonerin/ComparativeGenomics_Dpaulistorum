#!/bin/bash

for i in ./*.fasta

do

        python /space/Software/quast-5.0.2/quast.py $i

done
