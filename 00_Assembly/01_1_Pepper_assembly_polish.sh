#!/bin/bash -l
#Run on a cluster

#SBATCH -A proj-name
#SBATCH -p node -n 1
#SBATCH -t 3-00:00:00
#SBATCH -J job_name
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user mail

module load bioinfo-tools
module load PEPPER-Margin-DeepVariant/r0.4

mkdir AssemblyName_output

pepper_deepvariant_r0.4.sif run_pepper_margin_deepvariant call_variant -b ./input/AssemblyName_sorted.bam -f ./input/AssemblyName.fasta -o AssemblyName_output -p AssemblyName -t 20 --ont &>> ./AssemblyName_output/AssemblyName.log
