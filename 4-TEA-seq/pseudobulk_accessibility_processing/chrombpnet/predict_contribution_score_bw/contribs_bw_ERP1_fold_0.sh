

#!/bin/bash

JOB_NAME="contribs_bw_fold_0_ERP1"
DIR=$(pwd)

cat <<EOF
#BSUB -W 10:00
#BSUB -M 32000
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

echo "make temporary directory to save results"
mkdir /users/fero3l/contribs_bw_fold_0_ERP1/

echo "running chrombpnet model"
cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/chrombpnet/

chrombpnet contribs_bw \
--model-h5 cluster_specific_models/fold_0/chrombpnet_model_fold_0_ERP1/models/chrombpnet_nobias.h5 \
--regions /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/correlate_tea_atac_to_cite_rna_across_r7_clusters/peak_to_gene_correlation_within_tads/sig_peak_to_gene_peaks_10col.bed \
--genome /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.fa \
--chrom-sizes /data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.chrom.sizes \
--output-prefix /users/fero3l/contribs_bw_fold_0_ERP1/contribs_bw_fold_0_ERP1


echo "moving results to salomonis2"

mv /users/fero3l/contribs_bw_fold_0_ERP1/ \
/data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/chrombpnet/contribs_bw_expanded_peaks_fold_0/


echo "Finished."


EOF
# ./<file_name> | bsub