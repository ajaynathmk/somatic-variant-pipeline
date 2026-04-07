#!/bin/bash
# =============================================================================
# Script 1: Environment Setup & Data Download
# =============================================================================

set -euo pipefail

eval "$(micromamba shell hook --shell bash)"
micromamba activate somatic-variant-pipeline

echo ">>> Creating project directories..."
mkdir -p data/fastq ref results/fastqc vep_cache

echo ">>> Creating conda environment..."
micromamba env create -n somatic-variant-pipeline \
    -c bioconda -c conda-forge \
    bwa samtools gatk4 fastqc bcftools tabix cyvcf2 ensembl-vep -y

micromamba activate somatic-variant-pipeline

echo ">>> Downloading FASTQ files from Zenodo..."
BASE_URL="https://zenodo.org/record/2582555/files"

wget -c "${BASE_URL}/SLGFSK-N_231335_r1_chr5_12_17.fastq.gz" -P data/fastq/
wget -c "${BASE_URL}/SLGFSK-N_231335_r2_chr5_12_17.fastq.gz" -P data/fastq/
wget -c "${BASE_URL}/SLGFSK-T_231336_r1_chr5_12_17.fastq.gz" -P data/fastq/
wget -c "${BASE_URL}/SLGFSK-T_231336_r2_chr5_12_17.fastq.gz" -P data/fastq/

echo ">>> Downloading GRCh38 reference (chr5 slice)..."
wget -c "ftp://ftp.ensembl.org/pub/release-105/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.5.fa.gz" \
    -P ref/
gunzip ref/Homo_sapiens.GRCh38.dna.chromosome.5.fa.gz
mv ref/Homo_sapiens.GRCh38.dna.chromosome.5.fa ref/ref_slice.fa

echo ">>> Downloading VEP cache (GRCh38 v105) — this is ~14GB..."
cd vep_cache
wget -c "https://ftp.ensembl.org/pub/release-105/variation/indexed_vep_cache/homo_sapiens_vep_105_GRCh38.tar.gz"
tar -xzvf homo_sapiens_vep_105_GRCh38.tar.gz
cd ..

echo ">>> Setup complete."
