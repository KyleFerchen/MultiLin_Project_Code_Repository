

#!/bin/bash

JOB_NAME="cbnet_fold_0_CD127_MP"
DIR=$(pwd)

cat <<EOF
#BSUB -W 72:00
#BSUB -M 200000
#BSUB -n 1
#BSUB -q gpu-a100
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

echo "running chrombpnet model"
cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/chrombpnet/

chrombpnet pipeline \
-ibam /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_CD127_MP_bam_split.bam \
-d "ATAC" \
-g /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.fa \
-c /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.chrom.sizes \
-p peaks/peaks_no_blacklist_10_column_format.bed \
-n peaks/fold_0/negatives.bed \
-fl reference/splits/fold_0.json \
-b bias_model_ml1_fold_0/models/ml1_fold_0_bias.h5 \
-o /users/fero3l/chrombpnet_model_fold_0_CD127_MP/


echo "Moving folder back to salomonis2"
mv /users/fero3l/chrombpnet_model_fold_0_CD127_MP/ \
/data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/chrombpnet/cluster_specific_models/fold_0/

echo "Finished."


EOF
# ./<file_name> | bsub
