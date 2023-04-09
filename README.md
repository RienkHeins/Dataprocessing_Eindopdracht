# STATR pipeline snakemake

This repository contains a snakemake variant of the STATR pipeline. STATR can be used to process raw Ribo-Seq data to be used for multiple levels of translatome study. Creating .cov files with translation levels and a DESeq2 dataset. Furhter output comes in the form of a visualization in the form of a PCA plot, heatmap and dendrogram. The original study and pipeline can be found at the following locations:

Article: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7209825/ \
Original pipeline: https://github.com/robinald/STATR

## Installation

The pipeline is created in snakemake, python and R. Further, it uses trimmomatic, bowtie2, samtool and bedtools for data processing. The required R packages are installed by the pipeline.

Versions used: \
Snakemake 7.18 \
Python 3.11 \
R 4.0.2 \
Trimmomatic 0.39 \
Bowtie2 2.3.4 \
Samtools 1.15 \
BEDtools 2.27 \

All files needed are provided in the pipeline as the example versions as provided by the original pipeline. Required files are the input fastq.gz files, a design sheet file matching the input, a reference fasta file, a reference genome annotation file and a riboseq adapter file for the trimmomatic tool. 

## Pipeline overview

![Figure 1: DAG file of the pipeline](dag.png)

Figure 1 shows a visualization of the STATR pipeline. The pipeline is build up from 5 smk files, each with rules for specific tasks.\
\
trimmomatic.smk: \
data_trimming: Uses the trimmmomatic tool to trim the raw data by removing low quality reads and adapter sequences. \
\
mapping.smk: \
build_database: Builds a reference database from the reference genome file with bowtie2 to be used in the mapping done by bowtie2. \
mapping: Performs read mapping using bowtie2 and the reference database to turn the trimmed data files into .sam files. \
\
decompiling.smk: \
decompiling_bam: Uses samtools to turn the .sam files into .bam files. \
sort: Sorts bam files. \
bedtools: Turns bam files into bed files with bedtools. \
\
expression.smk: \
parse_genome_annotation: Uses python script to parse the genome annotation file into one to be used by bedtools. \
differential_expression: Uses bedtools and the new genome annotation file to create expression data files. \
create_DESeq_data: Uses a python script to turn the expression data into a format to be used in the DESeq2 tool in R. \
\
visualize.smk: \
install_packages: Installs required R packages for DESeq2 use. \
create_images: Uses a R script to create a PCA, heatmap and dendrogram from the data.

## Run pipeline
To run the pipeline clone the repository and use the following command: \
\
snakemake --snakefile workflow/Snakefile --cores n \
\
With n being the amount of cores used. The amount of threads used and the location of input files and directory's can be changed in the config.yaml file found in the config folder. \
\
To clean the pipeline use the clean rule with the following command, this will result in an empty pipeline: \
\
snakemake clean