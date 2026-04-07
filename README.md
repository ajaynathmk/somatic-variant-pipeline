# Somatic Variant Calling Pipeline

A shell-based somatic variant calling pipeline for paired tumor-normal whole-exome sequencing data, built using BWA-MEM, GATK4 Mutect2, and Ensembl VEP.

---

## Overview

This pipeline processes paired FASTQ files (tumor + normal) through the following steps:

```
FASTQ (Tumor + Normal)
       ↓
   FastQC (QC)
       ↓
 BWA-MEM (Alignment → BAM)
       ↓
  GATK Mutect2 (Somatic Variant Calling → VCF)
       ↓
 FilterMutectCalls (Variant Filtering)
       ↓
  Ensembl VEP (Annotation)
       ↓
 annotated_somatic.vcf
```

---

## Tools & Versions

| Tool | Version | Purpose |
|---|---|---|
| BWA-MEM | — | Read alignment |
| SAMtools | — | BAM manipulation |
| GATK4 | — | Variant calling & filtering |
| FastQC | — | Quality control |
| BCFtools | — | VCF stats & filtering |
| Ensembl VEP | 105 | Variant annotation |

---

## Dataset

Test data sourced from [Zenodo record 2582555](https://zenodo.org/record/2582555) — a chr5 slice (12–17 Mb) of paired tumor-normal WES data.

| File | Description |
|---|---|
| `SLGFSK-N_231335_r1/r2` | Normal sample (R1 + R2) |
| `SLGFSK-T_231336_r1/r2` | Tumor sample (R1 + R2) |

Reference genome: `Homo_sapiens.GRCh38.dna.chromosome.5` (Ensembl release 105)

---

## Requirements

- [micromamba](https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html) (or conda)
- ~20 GB disk space (reference + VEP cache + outputs)
- 8+ CPU threads recommended

---

## Usage

### Step 1 — Clone the repository

```bash
git clone https://github.com/<your-username>/somatic-variant-pipeline.git
cd somatic-variant-pipeline
```

### Step 2 — Run the full pipeline

```bash
bash run_pipeline.sh
```

Or run individual steps:

```bash
bash scripts/01_setup_environment.sh   # Create env & download data
bash scripts/02_quality_control.sh     # FastQC
bash scripts/03_alignment.sh           # BWA-MEM + BAM indexing
bash scripts/04_variant_calling.sh     # Mutect2 + FilterMutectCalls
bash scripts/05_annotation.sh          # Ensembl VEP
```

---

## Project Structure

```
somatic-variant-pipeline/
├── scripts/
│   ├── 01_setup_environment.sh
│   ├── 02_quality_control.sh
│   ├── 03_alignment.sh
│   ├── 04_variant_calling.sh
│   └── 05_annotation.sh
├── run_pipeline.sh
├── data/fastq/          # Raw FASTQ files (not tracked)
├── ref/                 # Reference genome (not tracked)
├── vep_cache/           # VEP cache (not tracked)
├── results/             # Pipeline outputs (not tracked)
├── .gitignore
└── README.md
```

---

## Notes

- Large files (`data/`, `ref/`, `vep_cache/`, `results/`) are excluded from version control via `.gitignore`. Re-download them using `scripts/01_setup_environment.sh`.
- The VEP cache download (~14 GB) is the most time-consuming step.
- Mutect2 is run on the interval `5:12000000-17000000` matching the test dataset.

---

## Author

Ajaynath Meethal Kandy  
M.Sc. Life Science Informatics — Deggendorf Institute of Technology  
[github.com/ajaynathmk](https://github.com/ajaynathmk)
