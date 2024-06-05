#!/bin/bash

JOB_NAME="train_bias_ml1_fold_0"
DIR=$(pwd)

cat <<EOF
#BSUB -W 72:00
#BSUB -M 200000
#BSUB -n 1
#BSUB -q gpu-v100
#BSUB -gpu "num=1"
#BSUB -e $DIR/logs/%J_$JOB_NAME.err
#BSUB -o $DIR/logs/%J_$JOB_NAME.out
#BSUB -J $JOB_NAME

echo "loading anaconda3"
module load anaconda3

echo "activating conda env"
source activate /users/fero3l/Env/chrombpnet

echo "loading cuda"
module load cuda/11.7

cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/chrombpnet/

chrombpnet bias pipeline \
-ibam /data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC35_Xuan/211202_Grimes_GSL-PY-2514_TEA-Seq/cellRanger-ARC/AS_TEAr_ML1/AS_TEAr_ML1/outs/atac_possorted_bam.bam \
-d "ATAC" \
-g /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.fa \
-c /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.chrom.sizes \
-p peaks/peaks_no_blacklist_10_column_format.bed \
-n peaks/fold_0/negatives.bed \
-fl reference/splits/fold_0.json \
-b 0.5 \
-o bias_model_ml1_fold_0/ \
-fp ml1_fold_0


echo "Finished."


EOF
# ./<file_name> | bsub