JOB_NAME="merged_macs2_set_03"
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


# Set 3
macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MPP4_Nkx2_3_bam_split.bam \
-n MPP4_Nkx2_3 --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MPP4_Ccr9_bam_split.bam \
-n MPP4_Ccr9 --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MKP_bam_split.bam \
-n MKP --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MEP_bam_split.bam \
-n MEP --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_HSCP_MKP_bam_split.bam \
-n HSCP_MKP --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_HSCP_HPC_Tk1_bam_split.bam \
-n HSCP_HPC_Tk1 --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits



EOF
# ./<script_name> | bsub