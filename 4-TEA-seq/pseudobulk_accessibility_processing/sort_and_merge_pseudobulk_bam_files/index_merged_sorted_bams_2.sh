JOB_NAME="merged_sorted_index_2"
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

# 12-22
samtools index merged_sorted_cluster_MPP4_Nkx2_3_bam_split.bam
samtools index merged_sorted_cluster_MPP4_Ccr9_bam_split.bam
samtools index merged_sorted_cluster_MKP_bam_split.bam
samtools index merged_sorted_cluster_MEP_bam_split.bam
samtools index merged_sorted_cluster_HSCP_MKP_bam_split.bam
samtools index merged_sorted_cluster_HSCP_HPC_Tk1_bam_split.bam
samtools index merged_sorted_cluster_HSCP_HPC_Hist1h2af_bam_split.bam
samtools index merged_sorted_cluster_HSCP_HPC_Cenpf_bam_split.bam
samtools index merged_sorted_cluster_HSCP_ERP1_bam_split.bam
samtools index merged_sorted_cluster_ERP1_bam_split.bam
samtools index "merged_sorted_cluster_Ebf1+ proB_Hmga2_bam_split.bam"


EOF
# ./<script_name> | bsub


