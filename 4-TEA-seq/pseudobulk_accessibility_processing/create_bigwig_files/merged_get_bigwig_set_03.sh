JOB_NAME="get_bw_set_03"
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


# Set 3
bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MPP4_Nkx2_3_bam_split.bam \
-o MPP4_Nkx2_3.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MPP4_Ccr9_bam_split.bam \
-o MPP4_Ccr9.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MKP_bam_split.bam \
-o MKP.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MEP_bam_split.bam \
-o MEP.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_HSCP_MKP_bam_split.bam \
-o HSCP_MKP.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_HSCP_HPC_Tk1_bam_split.bam \
-o HSCP_HPC_Tk1.bw



EOF