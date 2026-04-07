#!/bin/bash
# =============================================================================
# Script 2: Quality Control with FastQC
# =============================================================================

set -euo pipefail

eval "$(micromamba shell hook --shell bash)"
micromamba activate somatic-variant-pipeline

echo ">>> Running FastQC on all FASTQ files..."
mkdir -p results/fastqc

fastqc -o results/fastqc -t 4 data/fastq/*.fastq.gz

echo ">>> FastQC complete. Results saved to results/fastqc/"
