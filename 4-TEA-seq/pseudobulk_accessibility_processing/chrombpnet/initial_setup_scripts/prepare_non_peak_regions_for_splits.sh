#!/bin/bash

JOB_NAME="prepare_non_peak_regions_chrombpnet"
DIR=$(pwd)

cat <<EOF
#BSUB -W 48:00
#BSUB -M 200000
#BSUB -n 12
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

# fold_0
chrombpnet prep nonpeaks -g /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.fa \
-p peaks/peaks_no_blacklist_10_column_format.bed \
-c  /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.chrom.sizes \
-fl reference/splits/fold_0.json \
-br /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.blacklist.bed \
-o peaks/fold_0

# fold_1
chrombpnet prep nonpeaks -g /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.fa \
-p peaks/peaks_no_blacklist_10_column_format.bed \
-c  /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.chrom.sizes \
-fl reference/splits/fold_1.json \
-br /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.blacklist.bed \
-o peaks/fold_1

# fold_2
chrombpnet prep nonpeaks -g /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.fa \
-p peaks/peaks_no_blacklist_10_column_format.bed \
-c  /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.chrom.sizes \
-fl reference/splits/fold_2.json \
-br /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.blacklist.bed \
-o peaks/fold_2

# fold_3
chrombpnet prep nonpeaks -g /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.fa \
-p peaks/peaks_no_blacklist_10_column_format.bed \
-c  /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.chrom.sizes \
-fl reference/splits/fold_3.json \
-br /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.blacklist.bed \
-o peaks/fold_3

# fold_4
chrombpnet prep nonpeaks -g /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.fa \
-p peaks/peaks_no_blacklist_10_column_format.bed \
-c  /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.chrom.sizes \
-fl reference/splits/fold_4.json \
-br /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.blacklist.bed \
-o peaks/fold_4




EOF
# ./<file_name> | bsub

