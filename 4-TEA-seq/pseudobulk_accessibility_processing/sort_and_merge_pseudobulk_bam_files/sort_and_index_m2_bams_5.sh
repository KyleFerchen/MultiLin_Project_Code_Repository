JOB_NAME="sort_index_bams_m2_5"
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


# 44-53
samtools sort -o "sorted_cluster_ERP2_bam_split.bam" -@ 5 "cluster_ERP2_bam_split.bam"
samtools index "sorted_cluster_ERP2_bam_split.bam"

samtools sort -o "sorted_cluster_ERP1_bam_split.bam" -@ 5 "cluster_ERP1_bam_split.bam"
samtools index "sorted_cluster_ERP1_bam_split.bam"

samtools sort -o "sorted_cluster_DN4_DP_trans_Hist1h3c_bam_split.bam" -@ 5 "cluster_DN4_DP_trans_Hist1h3c_bam_split.bam"
samtools index "sorted_cluster_DN4_DP_trans_Hist1h3c_bam_split.bam"

samtools sort -o "sorted_cluster_CLP2_bam_split.bam" -@ 5 "cluster_CLP2_bam_split.bam"
samtools index "sorted_cluster_CLP2_bam_split.bam"

samtools sort -o "sorted_cluster_CLP1_Rrm2_bam_split.bam" -@ 5 "cluster_CLP1_Rrm2_bam_split.bam"
samtools index "sorted_cluster_CLP1_Rrm2_bam_split.bam"

samtools sort -o "sorted_cluster_CLP1_Hist1h1c_bam_split.bam" -@ 5 "cluster_CLP1_Hist1h1c_bam_split.bam"
samtools index "sorted_cluster_CLP1_Hist1h1c_bam_split.bam"

samtools sort -o "sorted_cluster_CHILP_bam_split.bam" -@ 5 "cluster_CHILP_bam_split.bam"
samtools index "sorted_cluster_CHILP_bam_split.bam"

samtools sort -o "sorted_cluster_CD127_MP_bam_split.bam" -@ 5 "cluster_CD127_MP_bam_split.bam"
samtools index "sorted_cluster_CD127_MP_bam_split.bam"

samtools sort -o "sorted_cluster_Baso_bam_split.bam" -@ 5 "cluster_Baso_bam_split.bam"
samtools index "sorted_cluster_Baso_bam_split.bam"

samtools sort -o "sorted_cluster_BMCP_bam_split.bam" -@ 5 "cluster_BMCP_bam_split.bam"
samtools index "sorted_cluster_BMCP_bam_split.bam"



EOF
# ./<script_name> | bsub
