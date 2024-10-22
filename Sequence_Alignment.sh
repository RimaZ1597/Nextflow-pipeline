#!/bin/bash
# File name : Sequence_Alignment.sh
# Author : Rima

#Control - SRR7080719
wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR708/009/SRR7080719/SRR7080719.fastq.gz

#Treated - SRR7080718
wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR708/008/SRR7080718/SRR7080718.fastq.gz

#Download Reference Genome(Human)
wget -c http://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chr1.fa.gz
.
.
wget -c http://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chrY.fa.gz
gunzip *.gz

#download FastQC To get the Quality report of raw data
fastqc Control_SRR7080719.fastq treated_SRR7080718.fastq

#aligning sequencing reads to long reference sequences using Bowtie 2
#here i build the index only for one chromosome of the human genome

#Indexing using Bowtie:
bowtie2-build human_Genome.fa human_Genome

# This command will output 6 files that constitute the index.

#human_Genome _bowtie_index.1.bt2
#human_Genome _index.2.bt2
#human_Genome _bowtie_index.3.bt2
#human_Genome _bowtie_index.4.bt2
#human_Genome _bowtie_index.rev.1.bt2
#human_Genome _bowtie_index.rev.2.bt2

#Align the Control_SRR7080719 reads using Bowtie2:
bowtie2 --very-sensitive -x human_Genome -q Control_SRR7080719.fastq -p 2 >Control_SRR7080719.sam

Align the treated_SRR7080718 reads using Bowtie2:
bowtie2 --very-sensitive -x human_Genome -q treated_SRR7080718.fastq -p 2 >treated_SRR7080718.sam

#Output files generated after running Bowtie for alignment:
#Control_SRR7080719.sam
#treated_SRR7080718.sam

#Converting SAM to BAM using samtools :
samtools view -bStest.sam > test.bam

#sort sam file into bam sorted:
samtools sort Control_SRR7080719.sam > Control_SRR7080719.bam
samtools sort treated_SRR7080718.sam > treated_SRR7080718.bam

#Remove duplicate reads
samtools-1.9/samtools markdup Control_SRR7080719.bam rmdup.Control_SRR7080719.bam
samtools-1.9/samtools markdup treated_SRR7080718.bam rmdup.treated_SRR7080718.bam

#Only pick reads which is mapping uniquely
samtools-1.9/samtools view -b -q 10 rmdup.Control_SRR7080719.bam >unique.rmdup.Control_SRR7080719.bam
samtools-1.9/samtools view -b -q 10 rmdup.treated_SRR7080718.bam >unique.rmdup.treated_SRR7080718.bam

#Indexing of .bam
samtools-1.9/samtools index unique.rmdup.Control_SRR7080719.bam
samtools-1.9/samtools index unique.rmdup.treated_SRR7080718.bam

