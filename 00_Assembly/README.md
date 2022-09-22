### Whole genome assemblies produced:

* Whole genome sequencing at Klasson's Lab
	* D. paulistorum O11
	* D. paulistorum MS
	* D. paulistorum A28

* Retreived published reads:
	* D. paulistorum L12
	* D. paulistorum L06
	* D. willistoni LG3
	* D. willistoni 00
	* D. tropicalis
	* D. insularis
	* D. sp
	* D. sucinea

Data from the article by Kim *et al.* 2021 [Highly contiguous assemblies of 101 drosophilid genomes](https://elifesciences.org/articles/66405)

## Sub-sample of reads
Using [Filt-long v0.2.1](https://github.com/rrwick/Filtlong)
|Species|Starting number of reads|Starting base pairs|Starting coverage|Subsampling method|Number of reads post-subsample|Base pairs post-subsample|Coverage post-subsample|
|:---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|D. paulistorum O11|1376601|19454247303|77|[Quality priority, 50X](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/00_D_paulistorum_O11_subsample.sh)|827899|12500020744|50|
|D. paulistorum MS|2738679|23800779581|91|[Length priority, 40X, using non-downsampled assembly as reference](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/00_D_paulistorum_MS_subsample.sh)|430957|10000006739|38|
|D. paulistorum A28|3424749|27698779973|113|[Length priority, 40X](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/00_D_paulistorum_A28_subsample.sh)|318515|10000006664|41|
|D. paulistorum L12|1461479|8394212233|35|No subsample|-|-|-|
|D. paulistorum L06|1178699|13536125176|50|No subsample|-|-|-|
|D. willistoni LG3|-|-|-|No subsample|-|-|-|
|D. willistoni 00|-|-|-|No subsample|-|-|-|
|D. tropicalis|-|-|-|No subsample|-|-|-|
|D. insularis|-|-|-|No subsample|-|-|-|
|D. sp|-|-|-|No subsample|-|-|-|
|D. sucinea|-|-|-|No subsample|-|-|-|


## Whole genome assembly
Using [NextDenovo v2.5.0](https://github.com/Nextomics/NextDenovo/releases/tag/v2.5.0)

(Example with D. paulistorum A28)

Create a folder for each assembly to be made

`mkdir A28_nextdenovo`

`cd A28_nextdenovo`

Copy the sub-sampled (For Dpau O11,MS,A28), or not (all the rest) fastq file to the folder:

`cp /path/read_data.fastq ./A28_length_filtered_40X.fastq.gz`

Create input.fofn with assembly location/name in folder:

`ls *fastq.gz | cat > input.fofn`

Create run.cfg file:
```
[General]
job_type = local
job_prefix = nextDenovo
task = all
rewrite = yes
deltmp = yes
parallel_jobs = 4
input_type = raw
read_type = ont # clr, ont, hifi
input_fofn = /space/no_backup/merce/nextdenovo/filter_reads/A28_filtered_40X_length/input.fofn
workdir = /space/no_backup/merce/nextdenovo/filter_reads/A28_filtered_40X_length/A28_nextdenovo_filter_40X_length

[correct_option]
read_cutoff = 1k
genome_size = 250m
sort_options = -m 7g -t 2
minimap2_options_raw = -t 3
pa_correction = 17
correction_options = -p 2

[assemble_option]
minimap2_options_cns = -t 3
nextgraph_options = -a 1
```

One must adapt the settings according to the capacity of your own computer/server in which you are running it, check guidelines [here](https://nextdenovo.readthedocs.io/en/latest/OPTION.html) and [here](https://nextdenovo.readthedocs.io/en/latest/FAQ.html#how-to-optimize-parallel-computing-parameters).

After assembly, contigs are renamed with [this script](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/fasta_rename_nextdenovo.pl) to keep them simple and without spaces nor symbols.


## Assembly polish

* Map long reads to genome assembly with [Minimap2](https://github.com/lh3/minimap2) and [samtools](https://github.com/samtools/samtools)
	* Commands [here](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/01_0_map_long_reads_assembly_polish.sh)

* Use [P.E.P.P.E.R-Marign-DeepVariant r.0.4](https://github.com/kishwarshafin/pepper/releases/tag/r0.4) to call variants
	* Commands [here](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/01_1_Pepper_assembly_polish.sh)

* Filter VCF to
`QUAL>=5 && FMT/DP>=40 && FMT/GQ>=20 && FMT/VAF>=0.6` in MS, A28, O11, D_paulistorum_L06, D_sp, D_tropicalis
`QUAL>=5 && FMT/DP>=20 && FMT/GQ>=20 && FMT/VAF>=0.6` in D_sucinea, D_insularis, D_willistoni_00, D_willistoni_LG3

* Change the variants left in the VCF on the genome assembly with [bcftools](https://github.com/samtools/bcftools)
	* Commands [here](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/01_2_filterVCF_post-PEPPER_assembly_polish.sh)

* Map Illumina reads to the genome assembly using [BWA](https://github.com/lh3/bwa) and [samtools](https://github.com/samtools/samtools)
	* Commands [here](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/01_3_pilon_assembly_polish.sh)
	* Illumina sequences from Klasson's lab:
		* D. paulistorum O11
		* D. paulistorum MS (Used for D. paulistorum L12 assembly as well)
		* D. paulistorum A28
		* D. tropicalis
	* Illumina sequences from [Kim *et al.* 2021](https://elifesciences.org/articles/66405)
		* D. insularis
		* D. willistoni 00
		* D. willistoni LG3
		* D. sucinea
		* D. sp (possible D. sucinea as well)

* Run [Pilon v1.24](https://github.com/broadinstitute/pilon) assembly polish
	* Commands [here](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/01_3_pilon_assembly_polish.sh)


## Assembly assessment

* Run [BUSCO v5.2.2](https://gitlab.com/ezlab/busco/-/releases/5.2.2)
	* Commands [here](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/02_BUSCO_assembly_evaluation.sh)

* Run [Quast v5.0.2](http://bioinf.spbau.ru/quast)
	* Commands [here](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/02_QUAST_assembly_evaluation.sh)
