## Whole genome assemblies produced:

#### Whole genome sequencing at Klasson's Lab

* *D. paulistorum* O11
* *D. paulistorum* MS
* *D. paulistorum* A28

#### Retreived published reads:

* *D. paulistorum* L12 [(SRR13070664)](https://www.ncbi.nlm.nih.gov/sra/SRX9518195)
* *D. paulistorum* L06 [(SRR13070744)](https://www.ncbi.nlm.nih.gov/sra/SRX9518114)
* *D. willistoni* LG3 [(SRR13070645)](https://www.ncbi.nlm.nih.gov/sra/SRX9518214)
* *D. willistoni* 00 [(SRR13070590)](https://www.ncbi.nlm.nih.gov/sra/SRX9518268)
* *D. tropicalis* [(SRR13070605)](https://www.ncbi.nlm.nih.gov/sra/SRX9518253)
* *D. insularis* [(SRR13070745)](https://www.ncbi.nlm.nih.gov/sra/SRX9518113)
* *D. sp* [(SRR13070648)](https://www.ncbi.nlm.nih.gov/sra/SRX9518211)(Possible *D. sucinea*)
* *D. sucinea* [(SRR13070647)](https://www.ncbi.nlm.nih.gov/sra/SRX9518212)(In NCBI as D. nebulosa)
* *D. equinoxialis* [(SRR13070606)](https://www.ncbi.nlm.nih.gov/sra/SRX9518252)

Data from the article by Kim *et al.* 2021 [Highly contiguous assemblies of 101 drosophilid genomes](https://elifesciences.org/articles/66405)

## Sub-sample of reads
Using [Filt-long v0.2.1](https://github.com/rrwick/Filtlong)
|Species|Starting number of reads|Starting base pairs|Starting coverage|Subsampling method|Number of reads post-subsample|Base pairs post-subsample|Coverage post-subsample|
|:---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|D. paulistorum O11|1376601|19454247303|77|[Quality priority, 50X](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/Scripts/00_D_paulistorum_O11_subsample.sh)|827899|12500020744|50|
|D. paulistorum MS|2738679|23800779581|91|[Length priority, 40X, using non-downsampled assembly as reference](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/Scripts/00_D_paulistorum_MS_subsample.sh)|430957|10000006739|38|
|D. paulistorum A28|3424749|27698779973|113|[Length priority, 40X](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/Scripts/00_D_paulistorum_A28_subsample.sh)|318515|10000006664|41|
|D. paulistorum L12|1461479|8394212233|35|No subsample|-|-|-|
|D. paulistorum L06|1178699|13536125176|50|No subsample|-|-|-|
|D. willistoni LG3|601201|9119677023|-|No subsample|-|-|-|
|D. willistoni 00|1867798|5701144432|-|No subsample|-|-|-|
|D. tropicalis|2208635|11915513684|-|No subsample|-|-|-|
|D. insularis|1291630|7719888113|-|No subsample|-|-|-|
|D. sp|545133|8072417990|-|No subsample|-|-|-|
|D. sucinea|377564|7844680311|-|No subsample|-|-|-|
|D. equinoxialis|1913794|10284175436|-|No subsample|-|-|-|


## Whole genome assembly
Using [NextDenovo v2.5.0](https://github.com/Nextomics/NextDenovo/releases/tag/v2.5.0)

(Example with *D. paulistorum* A28)

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

After assembly, contigs are renamed with [this script](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/Scripts/fasta_rename_nextdenovo.pl) to keep them simple and without spaces nor symbols.


## Assembly polish

### Long-read polish

Map long reads to genome assembly with [Minimap2](https://github.com/lh3/minimap2) and [samtools](https://github.com/samtools/samtools). Commands [here](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/Scripts/01_0_map_long_reads_assembly_polish.sh)

Use [P.E.P.P.E.R-Marign-DeepVariant r.0.4](https://github.com/kishwarshafin/pepper/releases/tag/r0.4) to call variants. Commands [here](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/Scripts/01_1_Pepper_assembly_polish.sh)

Filter VCF to

`QUAL>=5 && FMT/DP>=40 && FMT/GQ>=20 && FMT/VAF>=0.6` in MS, A28, O11, D_paulistorum_L06, D_sp, D_tropicalis, D_equinoxialis

`QUAL>=5 && FMT/DP>=20 && FMT/GQ>=20 && FMT/VAF>=0.6` in D_sucinea, D_insularis, D_willistoni_00, D_willistoni_LG3

Visual evidence for this selection:

![DP40 visual report](https://github.com/mmontonerin/ComparativeGenomics_Dpaulistorum/blob/main/00_Assembly/Visual_Reports/PEPPER_visual_report/DP40.png)

![DP20 visual report](https://github.com/mmontonerin/ComparativeGenomics_Dpaulistorum/blob/main/00_Assembly/Visual_Reports/PEPPER_visual_report/DP20.png)

Example 1 from visual report [A28](https://github.com/mmontonerin/ComparativeGenomics_Dpaulistorum/blob/main/00_Assembly/Visual_Reports/PEPPER_visual_report/A28.visual_report.html), example 2 from visual report [D_willistoni_00](https://github.com/mmontonerin/ComparativeGenomics_Dpaulistorum/blob/main/00_Assembly/Visual_Reports/PEPPER_visual_report/D_willistoni_00.visual_report.html). All reports [here](https://github.com/mmontonerin/ComparativeGenomics_Dpaulistorum/blob/main/00_Assembly/Visual_Reports/PEPPER_visual_report).

Change the variants left in the VCF on the genome assembly with [bcftools](https://github.com/samtools/bcftools)

Commands to filter the VCF and change the assembly [here](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/Scripts/01_2_filterVCF_post-PEPPER_assembly_polish.sh)

### Short-read polish

Map Illumina reads to the genome assembly using [BWA](https://github.com/lh3/bwa) and [samtools](https://github.com/samtools/samtools). Commands [here](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/Scripts/01_3_pilon_assembly_polish.sh)

#### Illumina sequences from Klasson's lab:
* *D. paulistorum* O11
* *D. paulistorum* MS (Used for *D. paulistorum* L12 assembly as well)
* *D. paulistorum* A28
* *D. tropicalis*
* *D. equinoxialis*

#### Illumina sequences from [Kim *et al.* 2021](https://elifesciences.org/articles/66405)
* *D. insularis* [(SRR13070692)](https://www.ncbi.nlm.nih.gov/sra/SRX9518166)
* *D. willistoni* LG3 [(SRR13070636)](https://www.ncbi.nlm.nih.gov/sra/SRX9518222)
* *D. willistoni* 00 [(SRR6426003)](https://www.ncbi.nlm.nih.gov/sra/SRR6426003)
* *D. sucinea* [(SRR13070638)](https://www.ncbi.nlm.nih.gov/sra/SRX9518220)(In NCBI as *D. nebulosa*)
* *D. sp* [(SRR13070637)](https://www.ncbi.nlm.nih.gov/sra/SRX9518221)(Possible *D. sucinea*)

Run [Pilon v1.24](https://github.com/broadinstitute/pilon) assembly polish. Commands [here](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/Scripts/01_3_pilon_assembly_polish_3rounds.sh)

A total of 3 rounds of Pilon are run. The final number of changes were used to decide which number of rounds suffice with each genome assembly. Number of changes are counted with [this script](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/Scripts/01_4_count_changes.sh). 

It is enough with 2 rounds of Pilon, except for *D. paulistorum* L12, *D. paulistorum* L06, and *D. willistoni* 00, which required 3 rounds.


## Assembly assessment

Run [BUSCO v5.2.2](https://gitlab.com/ezlab/busco/-/releases/5.2.2). Commands [here](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/Scripts/02_BUSCO_assembly_evaluation.sh)

Run [Quast v5.0.2](http://bioinf.spbau.ru/quast). Commands [here](https://github.com/mmontonerin/Drosophila_wolbachia_infection_related_genes/blob/main/00_Assembly/Scripts/02_QUAST_assembly_evaluation.sh)
