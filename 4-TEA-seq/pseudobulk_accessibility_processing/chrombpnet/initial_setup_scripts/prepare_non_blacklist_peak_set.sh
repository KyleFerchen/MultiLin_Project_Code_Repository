#!/bin/bash

JOB_NAME="prepare_non_blacklist_regions_chrombpnet"
DIR=$(pwd)

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 2:00
#BSUB -n 1
#BSUB -M 32000
#BSUB -e $DIR/logs/%J_$JOB_NAME.err
#BSUB -o $DIR/logs/%J_$JOB_NAME.out
#BSUB -J $JOB_NAME

cd $DIR

echo "loading anaconda3"
module load anaconda3

echo "activating conda env"
source activate /users/fero3l/Env/chrombpnet

# echo "loading cuda"
# module load cuda/11.7

cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/

echo "carry out bedtools slop..."
bedtools slop \
-i /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.blacklist.bed \
-g /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.chrom.sizes \
-b 1057 \
> chrombpnet/peaks/temp.bed

echo "carry out bedtools intersect..."
bedtools intersect -v \
-a tea_r7_macs2_p_0_05_merged_peak_set/r7_tea_p_0_001_merged_peaks_with_tss_added.bed \
-b chrombpnet/peaks/temp.bed  \
> chrombpnet/peaks/peaks_no_blacklist.bed

rm chrombpnet/peaks/temp.bed

EOF
# ./<file_name> | bsub