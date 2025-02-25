JOB_NAME="sort_index_bams_h1_01"
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

cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_split_bams/H1/

# 8-14
samtools sort -o sorted_cluster_MPP5_Egr1_bam_split.bam -@ 5 cluster_MPP5_Egr1_bam_split.bam
samtools index sorted_cluster_MPP5_Egr1_bam_split.bam

samtools sort -o sorted_cluster_MPP4_Nkx2_3_bam_split.bam -@ 5 cluster_MPP4_Nkx2_3_bam_split.bam
samtools index sorted_cluster_MPP4_Nkx2_3_bam_split.bam

samtools sort -o sorted_cluster_MPP4_Hlf_bam_split.bam -@ 5 cluster_MPP4_Hlf_bam_split.bam
samtools index sorted_cluster_MPP4_Hlf_bam_split.bam

samtools sort -o sorted_cluster_MPP4_Ccr9_bam_split.bam -@ 5 cluster_MPP4_Ccr9_bam_split.bam
samtools index sorted_cluster_MPP4_Ccr9_bam_split.bam

samtools sort -o sorted_cluster_MKP_bam_split.bam -@ 5 cluster_MKP_bam_split.bam
samtools index sorted_cluster_MKP_bam_split.bam

samtools sort -o sorted_cluster_MEP_bam_split.bam -@ 5 cluster_MEP_bam_split.bam
samtools index sorted_cluster_MEP_bam_split.bam

samtools sort -o sorted_cluster_LT_HSC_Mllt3_bam_split.bam -@ 5 cluster_LT_HSC_Mllt3_bam_split.bam
samtools index sorted_cluster_LT_HSC_Mllt3_bam_split.bam



EOF
# ./<script_name> | bsub
