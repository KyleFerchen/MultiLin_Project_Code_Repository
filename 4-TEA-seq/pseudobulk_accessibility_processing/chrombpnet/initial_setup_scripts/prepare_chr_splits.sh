#!/bin/bash

JOB_NAME="prepare_chr_splits"
DIR=$(pwd)

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 1:00
#BSUB -n 1
#BSUB -M 4000
#BSUB -e $DIR/logs/%J_$JOB_NAME.err
#BSUB -o $DIR/logs/%J_$JOB_NAME.out
#BSUB -J $JOB_NAME

echo "loading anaconda3"
module load anaconda3

echo "activating conda env"
source activate /users/fero3l/Env/chrombpnet

# echo "loading cuda"
# module load cuda/11.7



cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/chrombpnet/

mkdir reference/
mkdir reference/splits/

# Filter out chromosomes that are not 1-19, and X/Y
head -n 21 /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.chrom.sizes \
> reference/mm10.chrom.subset.sizes


# Split train, validation, and test splits
# fold_0
chrombpnet prep splits -c reference/mm10.chrom.subset.sizes \
-tcr chr1 chr3 chr6 \
-vcr chr7 chr19 \
-op reference/splits/fold_0

# fold_1
chrombpnet prep splits -c reference/mm10.chrom.subset.sizes \
-tcr chr2 chr4 chr7 \
-vcr chr10 chr18 \
-op reference/splits/fold_1

# fold_2
chrombpnet prep splits -c reference/mm10.chrom.subset.sizes \
-tcr chrX chr5 chr10 \
-vcr chr8 chrY \
-op reference/splits/fold_2

# fold_3
chrombpnet prep splits -c reference/mm10.chrom.subset.sizes \
-tcr chr8 chr9 chr13 chr12 \
-vcr chr14 chr17 \
-op reference/splits/fold_3

# fold_4
chrombpnet prep splits -c reference/mm10.chrom.subset.sizes \
-tcr chr14 chr11 chr15 chr17 \
-vcr chr9 chr16 \
-op reference/splits/fold_4

EOF
# ./<script_name> | bsub