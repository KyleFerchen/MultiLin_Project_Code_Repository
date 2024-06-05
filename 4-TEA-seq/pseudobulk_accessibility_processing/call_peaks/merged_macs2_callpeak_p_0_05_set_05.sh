JOB_NAME="merged_macs2_set_05"
DIR=$(pwd)

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 60:00
#BSUB -M 32000
#BSUB -e $DIR/logs/%J_$JOB_NAME.err
#BSUB -o $DIR/logs/%J_$JOB_NAME.out
#BSUB -J $JOB_NAME

cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/
module load MACS/2.1.4


# Set 5
macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_pre_cDC1_Xcr1_bam_split.bam \
-n pre_cDC1_Xcr1 --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_pre_cDC1_Egfl8_bam_split.bam \
-n pre_cDC1_Egfl8 --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_immNeu_3_bam_split.bam \
-n immNeu_3 --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_immNeu_2_bam_split.bam \
-n immNeu_2 --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_immNeu_1_bam_split.bam \
-n immNeu_1 --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_cKit_Mast_bam_split.bam \
-n cKit_Mast --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits




EOF
# ./<script_name> | bsub