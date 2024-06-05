
#!/bin/bash

JOB_NAME="modisco_fold_0_MultiLin_2_Ms4a3"
DIR=$(pwd)

cat <<EOF
#BSUB -W 32:00
#BSUB -M 64000
#BSUB -n 8
#BSUB -e $DIR/logs/%J_$JOB_NAME.err
#BSUB -o $DIR/logs/%J_$JOB_NAME.out
#BSUB -J $JOB_NAME

echo "loading anaconda3"
module load anaconda3

echo "activating conda env"
source activate /users/fero3l/Env/tfmodisco_lite

# echo "loading cuda"
# module load cuda/11.7

echo "make temporary directory to save results"
mkdir /users/fero3l/modisco_fold_0_MultiLin_2_Ms4a3/

echo "move to analysis directory"
cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/chrombpnet/

modisco motifs -i contribs_bw_expanded_peaks_fold_0/contribs_bw_fold_0_MultiLin_2_Ms4a3/contribs_bw_fold_0_MultiLin_2_Ms4a3.counts_scores.h5 -n 1000000 -w 1000 -o /users/fero3l/modisco_fold_0_MultiLin_2_Ms4a3/modisco_results_MultiLin_2_Ms4a3.h5


echo "moving results to salomonis2"

mv /users/fero3l/modisco_fold_0_MultiLin_2_Ms4a3/modisco_results_MultiLin_2_Ms4a3.h5 /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/chrombpnet/tfmodisco_lite/fold_0/modisco_fold_0_MultiLin_2_Ms4a3/

rmdir /users/fero3l/modisco_fold_0_MultiLin_2_Ms4a3/

echo "Finished."


EOF
# ./<file_name> | bsub

