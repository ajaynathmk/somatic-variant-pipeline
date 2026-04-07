#!/bin/bash
# =============================================================================
# Script 3: Reference Indexing & Read Alignment (BWA-MEM)
# =============================================================================

set -euo pipefail

REF="ref/ref_slice.fa"

echo ">>> Indexing reference genome..."
bwa index "$REF"
samtools faidx "$REF"
gatk CreateSequenceDictionary -R "$REF"

echo ">>> Aligning normal sample..."
bwa mem -t 8 \
    -R '@RG\tID:normal\tSM:normal\tLB:lib1\tPL:ILLUMINA' \
    "$REF" \
    data/fastq/SLGFSK-N_231335_r1_chr5_12_17.fastq.gz \
    data/fastq/SLGFSK-N_231335_r2_chr5_12_17.fastq.gz \
    | samtools sort -o results/normal.bam -

echo ">>> Aligning tumor sample..."
bwa mem -t 8 \
    -R '@RG\tID:tumor\tSM:tumor\tLB:lib1\tPL:ILLUMINA' \
    "$REF" \
    data/fastq/SLGFSK-T_231336_r1_chr5_12_17.fastq.gz \
    data/fastq/SLGFSK-T_231336_r2_chr5_12_17.fastq.gz \
    | samtools sort -o results/tumor.bam -

echo ">>> Indexing BAM files..."
samtools index results/normal.bam
samtools index results/tumor.bam

echo ">>> Fixing BAM sort order with GATK SortSam..."
for SAMPLE in normal tumor; do
    gatk SortSam \
        -I results/${SAMPLE}.bam \
        -O results/${SAMPLE}_fixed.bam \
        --SORT_ORDER coordinate \
        --CREATE_INDEX true

    mv results/${SAMPLE}_fixed.bam results/${SAMPLE}.bam
    mv results/${SAMPLE}_fixed.bai results/${SAMPLE}.bam.bai
done

echo ">>> Alignment complete. BAM files saved to results/"
