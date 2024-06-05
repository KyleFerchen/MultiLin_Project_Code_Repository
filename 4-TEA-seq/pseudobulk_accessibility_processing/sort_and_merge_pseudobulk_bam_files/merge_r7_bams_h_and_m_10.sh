JOB_NAME="merge_bams_h_and_m_10"
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


### Clusters only in MultiLin
# sorted_cluster_CD127_MP_bam_split.bam
samtools merge tea_r7_merged_bams/merged_sorted_cluster_CD127_MP_bam_split.bam \
tea_r7_split_bams/M1/sorted_cluster_CD127_MP_bam_split.bam \
tea_r7_split_bams/M2/sorted_cluster_CD127_MP_bam_split.bam

# sorted_cluster_Baso_bam_split.bam
samtools merge tea_r7_merged_bams/merged_sorted_cluster_Baso_bam_split.bam \
tea_r7_split_bams/M1/sorted_cluster_Baso_bam_split.bam \
tea_r7_split_bams/M2/sorted_cluster_Baso_bam_split.bam

# sorted_cluster_BMCP_bam_split.bam
samtools merge tea_r7_merged_bams/merged_sorted_cluster_BMCP_bam_split.bam \
tea_r7_split_bams/M1/sorted_cluster_BMCP_bam_split.bam \
tea_r7_split_bams/M2/sorted_cluster_BMCP_bam_split.bam




### Clusters only in MultiLin M2
# sorted_cluster_pre_cDC2_bam_split.bam
cp tea_r7_split_bams/M2/sorted_cluster_pre_cDC2_bam_split.bam \
tea_r7_merged_bams/merged_sorted_cluster_pre_cDC2_bam_split.bam

# sorted_cluster_cMoP_S100a4_bam_split.bam
cp tea_r7_split_bams/M2/sorted_cluster_cMoP_S100a4_bam_split.bam \
tea_r7_merged_bams/merged_sorted_cluster_cMoP_S100a4_bam_split.bam

# sorted_cluster_cMoP_Mki67_bam_split.bam
cp tea_r7_split_bams/M2/sorted_cluster_cMoP_Mki67_bam_split.bam \
tea_r7_merged_bams/merged_sorted_cluster_cMoP_Mki67_bam_split.bam




EOF
# ./<script_name> | bsub



