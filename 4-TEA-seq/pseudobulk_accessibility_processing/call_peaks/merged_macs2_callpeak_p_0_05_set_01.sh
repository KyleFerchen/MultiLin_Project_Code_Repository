JOB_NAME="merged_macs2_set_01"
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

# Set 1
macs2 callpeak -t "/data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_Ebf1+ proB_Hmga2_bam_split.bam" \
-n "Ebf1+ proB_Hmga2" --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_ST_HSC_CC_Mac_1_bam_split.bam \
-n ST_HSC_CC_Mac_1 --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MPP4_Hlf_bam_split.bam \
-n MPP4_Hlf --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_LT_HSC_Mllt3_bam_split.bam \
-n LT_HSC_Mllt3 --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_HSC_Mac_Fcna_bam_split.bam \
-n HSC_Mac_Fcna --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_pre_MultiLin_2_bam_split.bam \
-n pre_MultiLin_2 --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits





EOF
# ./<script_name> | bsub