JOB_NAME="merged_sorted_index_4"
DIR=$(pwd)

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 60:00
#BSUB -n 5
#BSUB -M 32000
#BSUB -e $DIR/logs/%J_$JOB_NAME.err
#BSUB -o $DIR/logs/%J_$JOB_NAME.out
#BSUB -J $JOB_NAME

cd $DIR
module load samtools

cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/

# 34-44
samtools index merged_sorted_cluster_MultiLin_1_preBMCP_bam_split.bam
samtools index merged_sorted_cluster_MultiLin_1_bam_split.bam
samtools index merged_sorted_cluster_MultiLin_1_MEP_bam_split.bam
samtools index merged_sorted_cluster_ML_cell_cycle_bam_split.bam
samtools index merged_sorted_cluster_ML_Mast_bam_split.bam
samtools index merged_sorted_cluster_MDP_Irf8_bam_split.bam
samtools index merged_sorted_cluster_MDP_Cpa3_bam_split.bam
samtools index merged_sorted_cluster_IG2_proNeu1_bam_split.bam
samtools index merged_sorted_cluster_IG2_MP_bam_split.bam
samtools index merged_sorted_cluster_Eosinophils_bam_split.bam
samtools index merged_sorted_cluster_ETP_CC_4_bam_split.bam


EOF
# ./<script_name> | bsub


