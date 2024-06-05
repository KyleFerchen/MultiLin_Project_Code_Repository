JOB_NAME="get_bw_set_05"
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


# Set 5
bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_pre_cDC1_Xcr1_bam_split.bam \
-o pre_cDC1_Xcr1.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_pre_cDC1_Egfl8_bam_split.bam \
-o pre_cDC1_Egfl8.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_immNeu_3_bam_split.bam \
-o immNeu_3.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_immNeu_2_bam_split.bam \
-o immNeu_2.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_immNeu_1_bam_split.bam \
-o immNeu_1.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_cKit_Mast_bam_split.bam \
-o cKit_Mast.bw



EOF