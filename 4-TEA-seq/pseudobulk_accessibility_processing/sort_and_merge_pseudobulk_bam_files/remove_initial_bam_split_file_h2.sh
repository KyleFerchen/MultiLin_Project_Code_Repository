JOB_NAME="rm_bams_h2"
DIR=$(pwd)

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 60:00
#BSUB -n 1
#BSUB -M 8000
#BSUB -e $DIR/logs/%J_$JOB_NAME.err
#BSUB -o $DIR/logs/%J_$JOB_NAME.out
#BSUB -J $JOB_NAME

cd $DIR
module load samtools

cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_split_bams/H2/

rm cluster_pre_MultiLin_2_bam_split.bam
rm cluster_pre_MultiLin_1_bam_split.bam
rm cluster_eHSC_bam_split.bam
rm cluster_eHSC_Pcna_bam_split.bam
rm cluster_ST_HSC_bam_split.bam
rm cluster_ST_HSC_CC_Mac_1_bam_split.bam
rm cluster_MPP5_Flt3_bam_split.bam
rm cluster_MPP5_Egr1_bam_split.bam
rm cluster_MPP4_Nkx2_3_bam_split.bam
rm cluster_MPP4_Hlf_bam_split.bam
rm cluster_MPP4_Ccr9_bam_split.bam
rm cluster_MKP_bam_split.bam
rm cluster_MEP_bam_split.bam
rm cluster_LT_HSC_Mllt3_bam_split.bam
rm cluster_HSC_Mac_Fcna_bam_split.bam
rm cluster_HSCP_MKP_bam_split.bam
rm cluster_HSCP_HPC_Tk1_bam_split.bam
rm cluster_HSCP_HPC_Hist1h2af_bam_split.bam
rm cluster_HSCP_HPC_Cenpf_bam_split.bam
rm cluster_HSCP_ERP1_bam_split.bam
rm cluster_ERP1_bam_split.bam


EOF
# ./<script_name> | bsub
