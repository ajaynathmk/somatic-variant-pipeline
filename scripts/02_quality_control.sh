#!/bin/bash
# =============================================================================
# Script 2: Quality Control with FastQC
# =============================================================================

set -euo pipefail

echo ">>> Running FastQC on all FASTQ files..."
mkdir -p results/fastqc

fastqc -o results/fastqc -t 4 data/fastq/*.fastq.gz

echo ">>> FastQC complete. Results saved to results/fastqc/"
