JOB_NAME="merged_macs2_set_09"
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


# Set 9
macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_CLP2_bam_split.bam \
-n CLP2 --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_CLP1_Rrm2_bam_split.bam \
-n CLP1_Rrm2 --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_CLP1_Hist1h1c_bam_split.bam \
-n CLP1_Hist1h1c --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_CHILP_bam_split.bam \
-n CHILP --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits

macs2 callpeak -t /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_CD127_MP_bam_split.bam \
-n CD127_MP --outdir /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_peak_calling_p_0_05/ \
--nomodel --shift 37 --ext 73 -p 0.05 -B --SPMR --call-summits



EOF
# ./<script_name> | bsub