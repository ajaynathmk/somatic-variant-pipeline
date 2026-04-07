#!/bin/bash
# =============================================================================
# Script 4: Somatic Variant Calling (Mutect2) & Filtering
# =============================================================================

set -euo pipefail

REF="ref/ref_slice.fa"
INTERVAL="5:12000000-17000000"

echo ">>> Running Mutect2..."
gatk --java-options "-Xmx8G" Mutect2 \
    -R "$REF" \
    -I results/tumor.bam \
    -I results/normal.bam \
    -normal normal \
    -L "$INTERVAL" \
    --max-mnp-distance 0 \
    -O results/raw_somatic.vcf.gz

echo ">>> Raw variant stats:"
bcftools stats results/raw_somatic.vcf.gz | grep -E "number of records|SNPs|indels"

echo ">>> Running FilterMutectCalls..."
gatk FilterMutectCalls \
    -R "$REF" \
    -V results/raw_somatic.vcf.gz \
    -O results/filtered_somatic.vcf.gz

echo ">>> PASS variants after filtering:"
bcftools view -f PASS results/filtered_somatic.vcf.gz | grep -v "#" | wc -l

echo ">>> Variant calling and filtering complete."
