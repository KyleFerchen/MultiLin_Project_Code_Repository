JOB_NAME="get_bw_set_08"
DIR=$(pwd)

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 12:00
#BSUB -M 32000
#BSUB -e $DIR/logs/%J_$JOB_NAME.err
#BSUB -o $DIR/logs/%J_$JOB_NAME.out
#BSUB -J $JOB_NAME

cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bigwig/
module load samtools
module load deeptools


# Set 8
bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_Eosinophils_bam_split.bam \
-o Eosinophils.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_ETP_CC_4_bam_split.bam \
-o ETP_CC_4.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_ETP_A_0_bam_split.bam \
-o ETP_A_0.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_ERP2_bam_split.bam \
-o ERP2.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_DN4_DP_trans_Hist1h3c_bam_split.bam \
-o DN4_DP_trans_Hist1h3c.bw



EOF