JOB_NAME="get_bw_set_04"
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



# Set 4
bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_HSCP_HPC_Hist1h2af_bam_split.bam \
-o HSCP_HPC_Hist1h2af.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_HSCP_HPC_Cenpf_bam_split.bam \
-o HSCP_HPC_Cenpf.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_HSCP_ERP1_bam_split.bam \
-o HSCP_ERP1.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_ERP1_bam_split.bam \
-o ERP1.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_proNeu_1_bam_split.bam \
-o proNeu_1.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_proNeu_1_ADT_bam_split.bam \
-o proNeu_1_ADT.bw




EOF