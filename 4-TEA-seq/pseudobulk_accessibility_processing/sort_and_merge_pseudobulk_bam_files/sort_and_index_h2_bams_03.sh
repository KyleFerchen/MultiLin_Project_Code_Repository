JOB_NAME="sort_index_bams_h2_3"
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

cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_split_bams/H2/

# 15-21
samtools sort -o sorted_cluster_HSC_Mac_Fcna_bam_split.bam -@ 5 cluster_HSC_Mac_Fcna_bam_split.bam
samtools index sorted_cluster_HSC_Mac_Fcna_bam_split.bam

samtools sort -o sorted_cluster_HSCP_MKP_bam_split.bam -@ 5 cluster_HSCP_MKP_bam_split.bam
samtools index sorted_cluster_HSCP_MKP_bam_split.bam

samtools sort -o sorted_cluster_HSCP_HPC_Tk1_bam_split.bam -@ 5 cluster_HSCP_HPC_Tk1_bam_split.bam
samtools index sorted_cluster_HSCP_HPC_Tk1_bam_split.bam

samtools sort -o sorted_cluster_HSCP_HPC_Hist1h2af_bam_split.bam -@ 5 cluster_HSCP_HPC_Hist1h2af_bam_split.bam
samtools index sorted_cluster_HSCP_HPC_Hist1h2af_bam_split.bam

samtools sort -o sorted_cluster_HSCP_HPC_Cenpf_bam_split.bam -@ 5 cluster_HSCP_HPC_Cenpf_bam_split.bam
samtools index sorted_cluster_HSCP_HPC_Cenpf_bam_split.bam

samtools sort -o sorted_cluster_HSCP_ERP1_bam_split.bam -@ 5 cluster_HSCP_ERP1_bam_split.bam
samtools index sorted_cluster_HSCP_ERP1_bam_split.bam

samtools sort -o sorted_cluster_ERP1_bam_split.bam -@ 5 cluster_ERP1_bam_split.bam
samtools index sorted_cluster_ERP1_bam_split.bam


EOF
# ./<script_name> | bsub
