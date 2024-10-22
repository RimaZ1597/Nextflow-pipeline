#!/usr/bin/env nextflow

// Define the process for alignment
process align {
    input:
    file fastq from inputFile
    file referenceIndex from params.reference_index

    script:
    """
    bowtie2 --very-sensitive -x \${referenceIndex} -q \${fastq} -p 2 > \${fastq.baseName}.sam
    samtools view -bS \${fastq.baseName}.sam > \${fastq.baseName}.bam
    """
}

// Define your pipeline inputs
input:
file controlFastq
file treatedFastq

// Define your pipeline outputs
output:
file '/Users/rima/Documents/Module_08/Control_SRR7080719.bam' into controlBam
file '/Users/rima/Documents/Module_08/treated_SRR7080718.bam' into treatedBam

// Define pipeline parameters and options
params.reference_index = '/Users/rima/Documents/Module_08/human_Genome'

// Run the alignment process for Control_SRR7080719
align(controlFastq, referenceIndex)

// Run the alignment process for treated_SRR7080718
align(treatedFastq, referenceIndex)
