JOB_NAME="sort_index_bams_m2_1"
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


# 1-11
samtools sort -o "sorted_cluster_proNeu_1_bam_split.bam" -@ 5 "cluster_proNeu_1_bam_split.bam"
samtools index "sorted_cluster_proNeu_1_bam_split.bam"

samtools sort -o "sorted_cluster_proNeu_1_ADT_bam_split.bam" -@ 5 "cluster_proNeu_1_ADT_bam_split.bam"
samtools index "sorted_cluster_proNeu_1_ADT_bam_split.bam"

samtools sort -o "sorted_cluster_pre_cDC2_bam_split.bam" -@ 5 "cluster_pre_cDC2_bam_split.bam"
samtools index "sorted_cluster_pre_cDC2_bam_split.bam"

samtools sort -o "sorted_cluster_pre_cDC1_Xcr1_bam_split.bam" -@ 5 "cluster_pre_cDC1_Xcr1_bam_split.bam"
samtools index "sorted_cluster_pre_cDC1_Xcr1_bam_split.bam"

samtools sort -o "sorted_cluster_pre_cDC1_Egfl8_bam_split.bam" -@ 5 "cluster_pre_cDC1_Egfl8_bam_split.bam"
samtools index "sorted_cluster_pre_cDC1_Egfl8_bam_split.bam"

samtools sort -o "sorted_cluster_pre_MultiLin_2_bam_split.bam" -@ 5 "cluster_pre_MultiLin_2_bam_split.bam"
samtools index "sorted_cluster_pre_MultiLin_2_bam_split.bam"

samtools sort -o "sorted_cluster_pre_MultiLin_1_bam_split.bam" -@ 5 "cluster_pre_MultiLin_1_bam_split.bam"
samtools index "sorted_cluster_pre_MultiLin_1_bam_split.bam"

samtools sort -o "sorted_cluster_immNeu_3_bam_split.bam" -@ 5 "cluster_immNeu_3_bam_split.bam"
samtools index "sorted_cluster_immNeu_3_bam_split.bam"

samtools sort -o "sorted_cluster_immNeu_2_bam_split.bam" -@ 5 "cluster_immNeu_2_bam_split.bam"
samtools index "sorted_cluster_immNeu_2_bam_split.bam"

samtools sort -o "sorted_cluster_immNeu_1_bam_split.bam" -@ 5 "cluster_immNeu_1_bam_split.bam"
samtools index "sorted_cluster_immNeu_1_bam_split.bam"

samtools sort -o "sorted_cluster_eHSC_bam_split.bam" -@ 5 "cluster_eHSC_bam_split.bam"
samtools index "sorted_cluster_eHSC_bam_split.bam"



EOF
# ./<script_name> | bsub
