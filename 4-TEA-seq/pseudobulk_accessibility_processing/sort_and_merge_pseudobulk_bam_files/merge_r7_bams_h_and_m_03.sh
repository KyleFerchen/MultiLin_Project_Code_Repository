JOB_NAME="merge_bams_h_and_m_03"
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

cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/

## Prefixes
# H1: tea_r7_split_bams/H1/
# H2: tea_r7_split_bams/H2/
# M1: tea_r7_split_bams/M1/
# M2: tea_r7_split_bams/M2/


### Clusters in HSCP and MultiLin
# sorted_cluster_MPP5_Egr1_bam_split.bam
samtools merge tea_r7_merged_bams/merged_sorted_cluster_MPP5_Egr1_bam_split.bam \
tea_r7_split_bams/H1/sorted_cluster_MPP5_Egr1_bam_split.bam \
tea_r7_split_bams/H2/sorted_cluster_MPP5_Egr1_bam_split.bam \
tea_r7_split_bams/M1/sorted_cluster_MPP5_Egr1_bam_split.bam \
tea_r7_split_bams/M2/sorted_cluster_MPP5_Egr1_bam_split.bam

# sorted_cluster_MPP4_Nkx2_3_bam_split.bam
samtools merge tea_r7_merged_bams/merged_sorted_cluster_MPP4_Nkx2_3_bam_split.bam \
tea_r7_split_bams/H1/sorted_cluster_MPP4_Nkx2_3_bam_split.bam \
tea_r7_split_bams/H2/sorted_cluster_MPP4_Nkx2_3_bam_split.bam \
tea_r7_split_bams/M1/sorted_cluster_MPP4_Nkx2_3_bam_split.bam \
tea_r7_split_bams/M2/sorted_cluster_MPP4_Nkx2_3_bam_split.bam

# sorted_cluster_MPP4_Ccr9_bam_split.bam
samtools merge tea_r7_merged_bams/merged_sorted_cluster_MPP4_Ccr9_bam_split.bam \
tea_r7_split_bams/H1/sorted_cluster_MPP4_Ccr9_bam_split.bam \
tea_r7_split_bams/H2/sorted_cluster_MPP4_Ccr9_bam_split.bam \
tea_r7_split_bams/M1/sorted_cluster_MPP4_Ccr9_bam_split.bam \
tea_r7_split_bams/M2/sorted_cluster_MPP4_Ccr9_bam_split.bam

# sorted_cluster_MKP_bam_split.bam
samtools merge tea_r7_merged_bams/merged_sorted_cluster_MKP_bam_split.bam \
tea_r7_split_bams/H1/sorted_cluster_MKP_bam_split.bam \
tea_r7_split_bams/H2/sorted_cluster_MKP_bam_split.bam \
tea_r7_split_bams/M1/sorted_cluster_MKP_bam_split.bam \
tea_r7_split_bams/M2/sorted_cluster_MKP_bam_split.bam

# sorted_cluster_MEP_bam_split.bam
samtools merge tea_r7_merged_bams/merged_sorted_cluster_MEP_bam_split.bam \
tea_r7_split_bams/H1/sorted_cluster_MEP_bam_split.bam \
tea_r7_split_bams/H2/sorted_cluster_MEP_bam_split.bam \
tea_r7_split_bams/M1/sorted_cluster_MEP_bam_split.bam \
tea_r7_split_bams/M2/sorted_cluster_MEP_bam_split.bam

# sorted_cluster_HSCP_MKP_bam_split.bam
samtools merge tea_r7_merged_bams/merged_sorted_cluster_HSCP_MKP_bam_split.bam \
tea_r7_split_bams/H1/sorted_cluster_HSCP_MKP_bam_split.bam \
tea_r7_split_bams/H2/sorted_cluster_HSCP_MKP_bam_split.bam \
tea_r7_split_bams/M1/sorted_cluster_HSCP_MKP_bam_split.bam \
tea_r7_split_bams/M2/sorted_cluster_HSCP_MKP_bam_split.bam


EOF
# ./<script_name> | bsub
