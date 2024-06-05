JOB_NAME="sort_index_bams_m2_2"
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

cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_split_bams/M2/


# 11-22
samtools sort -o "sorted_cluster_eHSC_Pcna_bam_split.bam" -@ 5 "cluster_eHSC_Pcna_bam_split.bam"
samtools index "sorted_cluster_eHSC_Pcna_bam_split.bam"

samtools sort -o "sorted_cluster_cMoP_S100a4_bam_split.bam" -@ 5 "cluster_cMoP_S100a4_bam_split.bam"
samtools index "sorted_cluster_cMoP_S100a4_bam_split.bam"

samtools sort -o "sorted_cluster_cMoP_Mki67_bam_split.bam" -@ 5 "cluster_cMoP_Mki67_bam_split.bam"
samtools index "sorted_cluster_cMoP_Mki67_bam_split.bam"

samtools sort -o "sorted_cluster_cKit_Mast_bam_split.bam" -@ 5 "cluster_cKit_Mast_bam_split.bam"
samtools index "sorted_cluster_cKit_Mast_bam_split.bam"

samtools sort -o "sorted_cluster_alphaLP_bam_split.bam" -@ 5 "cluster_alphaLP_bam_split.bam"
samtools index "sorted_cluster_alphaLP_bam_split.bam"

samtools sort -o "sorted_cluster_ST_HSC_bam_split.bam" -@ 5 "cluster_ST_HSC_bam_split.bam"
samtools index "sorted_cluster_ST_HSC_bam_split.bam"

samtools sort -o "sorted_cluster_MultiLin_2_Ms4a3_bam_split.bam" -@ 5 "cluster_MultiLin_2_Ms4a3_bam_split.bam"
samtools index "sorted_cluster_MultiLin_2_Ms4a3_bam_split.bam"

samtools sort -o "sorted_cluster_MultiLin_2_F13a1_bam_split.bam" -@ 5 "cluster_MultiLin_2_F13a1_bam_split.bam"
samtools index "sorted_cluster_MultiLin_2_F13a1_bam_split.bam"

samtools sort -o "sorted_cluster_MultiLin_1_preBMCP_bam_split.bam" -@ 5 "cluster_MultiLin_1_preBMCP_bam_split.bam"
samtools index "sorted_cluster_MultiLin_1_preBMCP_bam_split.bam"

samtools sort -o "sorted_cluster_MultiLin_1_bam_split.bam" -@ 5 "cluster_MultiLin_1_bam_split.bam"
samtools index "sorted_cluster_MultiLin_1_bam_split.bam"

samtools sort -o "sorted_cluster_MultiLin_1_MEP_bam_split.bam" -@ 5 "cluster_MultiLin_1_MEP_bam_split.bam"
samtools index "sorted_cluster_MultiLin_1_MEP_bam_split.bam"


EOF
# ./<script_name> | bsub
