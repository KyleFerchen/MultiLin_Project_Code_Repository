JOB_NAME="rm_bams_m2"
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

cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_split_bams/M2/

rm "cluster_proNeu_1_bam_split.bam"
rm "cluster_proNeu_1_ADT_bam_split.bam"
rm "cluster_pre_cDC2_bam_split.bam"
rm "cluster_pre_cDC1_Xcr1_bam_split.bam"
rm "cluster_pre_cDC1_Egfl8_bam_split.bam"
rm "cluster_pre_MultiLin_2_bam_split.bam"
rm "cluster_pre_MultiLin_1_bam_split.bam"
rm "cluster_immNeu_3_bam_split.bam"
rm "cluster_immNeu_2_bam_split.bam"
rm "cluster_immNeu_1_bam_split.bam"
rm "cluster_eHSC_bam_split.bam"
rm "cluster_eHSC_Pcna_bam_split.bam"
rm "cluster_cMoP_S100a4_bam_split.bam"
rm "cluster_cMoP_Mki67_bam_split.bam"
rm "cluster_cKit_Mast_bam_split.bam"
rm "cluster_alphaLP_bam_split.bam"
rm "cluster_ST_HSC_bam_split.bam"
rm "cluster_MultiLin_2_Ms4a3_bam_split.bam"
rm "cluster_MultiLin_2_F13a1_bam_split.bam"
rm "cluster_MultiLin_1_preBMCP_bam_split.bam"
rm "cluster_MultiLin_1_bam_split.bam"
rm "cluster_MultiLin_1_MEP_bam_split.bam"
rm "cluster_MPP5_Flt3_bam_split.bam"
rm "cluster_MPP5_Egr1_bam_split.bam"
rm "cluster_MPP4_Nkx2_3_bam_split.bam"
rm "cluster_MPP4_Ccr9_bam_split.bam"
rm "cluster_ML_cell_cycle_bam_split.bam"
rm "cluster_ML_Mast_bam_split.bam"
rm "cluster_MKP_bam_split.bam"
rm "cluster_MEP_bam_split.bam"
rm "cluster_MDP_Irf8_bam_split.bam"
rm "cluster_MDP_Cpa3_bam_split.bam"
rm "cluster_IG2_proNeu1_bam_split.bam"
rm "cluster_IG2_MP_bam_split.bam"
rm "cluster_HSCP_MKP_bam_split.bam"
rm "cluster_HSCP_HPC_Tk1_bam_split.bam"
rm "cluster_HSCP_HPC_Hist1h2af_bam_split.bam"
rm "cluster_HSCP_HPC_Cenpf_bam_split.bam"
rm "cluster_HSCP_ERP1_bam_split.bam"
rm "cluster_Eosinophils_bam_split.bam"
rm "cluster_Ebf1+ proB_Hmga2_bam_split.bam"
rm "cluster_ETP_CC_4_bam_split.bam"
rm "cluster_ETP_A_0_bam_split.bam"
rm "cluster_ERP2_bam_split.bam"
rm "cluster_ERP1_bam_split.bam"
rm "cluster_DN4_DP_trans_Hist1h3c_bam_split.bam"
rm "cluster_CLP2_bam_split.bam"
rm "cluster_CLP1_Rrm2_bam_split.bam"
rm "cluster_CLP1_Hist1h1c_bam_split.bam"
rm "cluster_CHILP_bam_split.bam"
rm "cluster_CD127_MP_bam_split.bam"
rm "cluster_Baso_bam_split.bam"
rm "cluster_BMCP_bam_split.bam"

EOF
# ./<script_name> | bsub
