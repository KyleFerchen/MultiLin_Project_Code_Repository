JOB_NAME="merged_sorted_index_5"
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

# 45-57
samtools index merged_sorted_cluster_ETP_A_0_bam_split.bam
samtools index merged_sorted_cluster_ERP2_bam_split.bam
samtools index merged_sorted_cluster_DN4_DP_trans_Hist1h3c_bam_split.bam
samtools index merged_sorted_cluster_CLP2_bam_split.bam
samtools index merged_sorted_cluster_CLP1_Rrm2_bam_split.bam
samtools index merged_sorted_cluster_CLP1_Hist1h1c_bam_split.bam
samtools index merged_sorted_cluster_CHILP_bam_split.bam
samtools index merged_sorted_cluster_CD127_MP_bam_split.bam
samtools index merged_sorted_cluster_Baso_bam_split.bam
samtools index merged_sorted_cluster_BMCP_bam_split.bam
samtools index merged_sorted_cluster_pre_cDC2_bam_split.bam
samtools index merged_sorted_cluster_cMoP_S100a4_bam_split.bam
samtools index merged_sorted_cluster_cMoP_Mki67_bam_split.bam

EOF
# ./<script_name> | bsub


