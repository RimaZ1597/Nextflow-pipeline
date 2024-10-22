#!/usr/bin/env nextflow

// Declare syntax version
nextflow.enable.dsl=2

// Script parameters
params.inputFastqcControl = '/Users/rima/Documents/Module_08/fastq_pipeline/Control_SRR7080719.fastq'
params.inputFastqcTreated = '/Users/rima/Documents/Module_08/fastq_pipeline/treated_SRR7080718.fastq'

// Define a process for trimming and filtering
process trimAndFilter {

    input:
    path inputFastqc

    output:
    path "trimmed_${inputFastqc.baseName}"

    script:
    """
    # Use cutadapt to trim and filter reads
    cutadapt -q 20 -o trimmed_\${inputFastqc.baseName} \${inputFastqc}
    """
}

// Execute the process for each input file
workflow {

    // Create channels for input files
    inputFastqcControl_ch = Channel.fromPath(params.inputFastqcControl)
    inputFastqcTreated_ch = Channel.fromPath(params.inputFastqcTreated)

    // Connect the process to the input channels
    trimAndFilter(inputFastqcControl_ch)
    trimAndFilter(inputFastqcTreated_ch)
}
