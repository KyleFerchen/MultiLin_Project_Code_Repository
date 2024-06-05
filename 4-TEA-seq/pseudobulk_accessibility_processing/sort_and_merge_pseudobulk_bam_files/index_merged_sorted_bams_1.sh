JOB_NAME="merged_sorted_index_1"
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

# 1-11
samtools index merged_sorted_cluster_ST_HSC_CC_Mac_1_bam_split.bam
samtools index merged_sorted_cluster_MPP4_Hlf_bam_split.bam
samtools index merged_sorted_cluster_LT_HSC_Mllt3_bam_split.bam
samtools index merged_sorted_cluster_HSC_Mac_Fcna_bam_split.bam
samtools index merged_sorted_cluster_pre_MultiLin_2_bam_split.bam
samtools index merged_sorted_cluster_pre_MultiLin_1_bam_split.bam
samtools index merged_sorted_cluster_eHSC_bam_split.bam
samtools index merged_sorted_cluster_eHSC_Pcna_bam_split.bam
samtools index merged_sorted_cluster_ST_HSC_bam_split.bam
samtools index merged_sorted_cluster_MPP5_Flt3_bam_split.bam
samtools index merged_sorted_cluster_MPP5_Egr1_bam_split.bam

EOF
# ./<script_name> | bsub


