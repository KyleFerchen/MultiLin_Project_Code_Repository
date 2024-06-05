JOB_NAME="sort_index_bams_m1"
DIR=$(pwd)

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 60:00
#BSUB -n 5
#BSUB -M 32000
#BSUB -e $DIR/logs/%J.err
#BSUB -o $DIR/logs/%J.out
#BSUB -J $JOB_NAME

cd $DIR
module load samtools

cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_split_bams/M1/


# 1-10
samtools sort -o "sorted_cluster_proNeu_1_bam_split.bam" -@ 5 "cluster_proNeu_1_bam_split.bam"
samtools index "sorted_cluster_proNeu_1_bam_split.bam"

samtools sort -o "sorted_cluster_proNeu_1_ADT_bam_split.bam" -@ 5 "cluster_proNeu_1_ADT_bam_split.bam"
samtools index "sorted_cluster_proNeu_1_ADT_bam_split.bam"

samtools sort -o "sorted_cluster_pre_cDC1_Xcr1_bam_split.bam" -@ 5 "cluster_pre_cDC1_Xcr1_bam_split.bam"
samtools index "sorted_cluster_pre_cDC1_Xcr1_bam_split.bam"

samtools sort -o "sorted_cluster_pre_cDC1_Egfl8_bam_split.bam" -@ 5 "cluster_pre_cDC1_Egfl8_bam_split.bam"
samtools index "sorted_cluster_pre_cDC1_Egfl8_bam_split.bam"

samtools sort -o "sorted_cluster_pre_MultiLin_2_bam_split.bam" -@ 5 "cluster_pre_MultiLin_2_bam_split.bam"
samtools index "sorted_cluster_pre_MultiLin_2_bam_split.bam"

samtools sort -o "sorted_cluster_pre_MultiLin_1_bam_split.bam" -@ 5 "cluster_pre_MultiLin_1_bam_split.bam"
samtools index "sorted_cluster_pre_MultiLin_1_bam_split.bam"

samtools sort -o "sorted_cluster_immNeu_3_bam_split.bam" -@ 5 "cluster_immNeu_3_bam_split.bam"
samtools index "sorted_cluster_immNeu_3_bam_split.bam"

samtools sort -o "sorted_cluster_immNeu_2_bam_split.bam" -@ 5 "cluster_immNeu_2_bam_split.bam"
samtools index "sorted_cluster_immNeu_2_bam_split.bam"

samtools sort -o "sorted_cluster_immNeu_1_bam_split.bam" -@ 5 "cluster_immNeu_1_bam_split.bam"
samtools index "sorted_cluster_immNeu_1_bam_split.bam"

samtools sort -o "sorted_cluster_eHSC_bam_split.bam" -@ 5 "cluster_eHSC_bam_split.bam"
samtools index "sorted_cluster_eHSC_bam_split.bam"


# 11-20
samtools sort -o "sorted_cluster_eHSC_Pcna_bam_split.bam" -@ 5 "cluster_eHSC_Pcna_bam_split.bam"
samtools index "sorted_cluster_eHSC_Pcna_bam_split.bam"

samtools sort -o "sorted_cluster_cKit_Mast_bam_split.bam" -@ 5 "cluster_cKit_Mast_bam_split.bam"
samtools index "sorted_cluster_cKit_Mast_bam_split.bam"

samtools sort -o "sorted_cluster_alphaLP_bam_split.bam" -@ 5 "cluster_alphaLP_bam_split.bam"
samtools index "sorted_cluster_alphaLP_bam_split.bam"

samtools sort -o "sorted_cluster_ST_HSC_bam_split.bam" -@ 5 "cluster_ST_HSC_bam_split.bam"
samtools index "sorted_cluster_ST_HSC_bam_split.bam"

samtools sort -o "sorted_cluster_MultiLin_2_Ms4a3_bam_split.bam" -@ 5 "cluster_MultiLin_2_Ms4a3_bam_split.bam"
samtools index "sorted_cluster_MultiLin_2_Ms4a3_bam_split.bam"

samtools sort -o "sorted_cluster_MultiLin_2_F13a1_bam_split.bam" -@ 5 "cluster_MultiLin_2_F13a1_bam_split.bam"
samtools index "sorted_cluster_MultiLin_2_F13a1_bam_split.bam"

samtools sort -o "sorted_cluster_MultiLin_1_preBMCP_bam_split.bam" -@ 5 "cluster_MultiLin_1_preBMCP_bam_split.bam"
samtools index "sorted_cluster_MultiLin_1_preBMCP_bam_split.bam"

samtools sort -o "sorted_cluster_MultiLin_1_bam_split.bam" -@ 5 "cluster_MultiLin_1_bam_split.bam"
samtools index "sorted_cluster_MultiLin_1_bam_split.bam"

samtools sort -o "sorted_cluster_MultiLin_1_MEP_bam_split.bam" -@ 5 "cluster_MultiLin_1_MEP_bam_split.bam"
samtools index "sorted_cluster_MultiLin_1_MEP_bam_split.bam"

samtools sort -o "sorted_cluster_MPP5_Flt3_bam_split.bam" -@ 5 "cluster_MPP5_Flt3_bam_split.bam"
samtools index "sorted_cluster_MPP5_Flt3_bam_split.bam"


# 21-30
samtools sort -o "sorted_cluster_MPP5_Egr1_bam_split.bam" -@ 5 "cluster_MPP5_Egr1_bam_split.bam"
samtools index "sorted_cluster_MPP5_Egr1_bam_split.bam"

samtools sort -o "sorted_cluster_MPP4_Nkx2_3_bam_split.bam" -@ 5 "cluster_MPP4_Nkx2_3_bam_split.bam"
samtools index "sorted_cluster_MPP4_Nkx2_3_bam_split.bam"

samtools sort -o "sorted_cluster_MPP4_Ccr9_bam_split.bam" -@ 5 "cluster_MPP4_Ccr9_bam_split.bam"
samtools index "sorted_cluster_MPP4_Ccr9_bam_split.bam"

samtools sort -o "sorted_cluster_ML_cell_cycle_bam_split.bam" -@ 5 "cluster_ML_cell_cycle_bam_split.bam"
samtools index "sorted_cluster_ML_cell_cycle_bam_split.bam"

samtools sort -o "sorted_cluster_ML_Mast_bam_split.bam" -@ 5 "cluster_ML_Mast_bam_split.bam"
samtools index "sorted_cluster_ML_Mast_bam_split.bam"

samtools sort -o "sorted_cluster_MKP_bam_split.bam" -@ 5 "cluster_MKP_bam_split.bam"
samtools index "sorted_cluster_MKP_bam_split.bam"

samtools sort -o "sorted_cluster_MEP_bam_split.bam" -@ 5 "cluster_MEP_bam_split.bam"
samtools index "sorted_cluster_MEP_bam_split.bam"

samtools sort -o "sorted_cluster_MDP_Irf8_bam_split.bam" -@ 5 "cluster_MDP_Irf8_bam_split.bam"
samtools index "sorted_cluster_MDP_Irf8_bam_split.bam"

samtools sort -o "sorted_cluster_MDP_Cpa3_bam_split.bam" -@ 5 "cluster_MDP_Cpa3_bam_split.bam"
samtools index "sorted_cluster_MDP_Cpa3_bam_split.bam"

samtools sort -o "sorted_cluster_IG2_proNeu1_bam_split.bam" -@ 5 "cluster_IG2_proNeu1_bam_split.bam"
samtools index "sorted_cluster_IG2_proNeu1_bam_split.bam"


# 31-40
samtools sort -o "sorted_cluster_IG2_MP_bam_split.bam" -@ 5 "cluster_IG2_MP_bam_split.bam"
samtools index "sorted_cluster_IG2_MP_bam_split.bam"

samtools sort -o "sorted_cluster_HSCP_MKP_bam_split.bam" -@ 5 "cluster_HSCP_MKP_bam_split.bam"
samtools index "sorted_cluster_HSCP_MKP_bam_split.bam"

samtools sort -o "sorted_cluster_HSCP_HPC_Tk1_bam_split.bam" -@ 5 "cluster_HSCP_HPC_Tk1_bam_split.bam"
samtools index "sorted_cluster_HSCP_HPC_Tk1_bam_split.bam"

samtools sort -o "sorted_cluster_HSCP_HPC_Hist1h2af_bam_split.bam" -@ 5 "cluster_HSCP_HPC_Hist1h2af_bam_split.bam"
samtools index "sorted_cluster_HSCP_HPC_Hist1h2af_bam_split.bam"

samtools sort -o "sorted_cluster_HSCP_HPC_Cenpf_bam_split.bam" -@ 5 "cluster_HSCP_HPC_Cenpf_bam_split.bam"
samtools index "sorted_cluster_HSCP_HPC_Cenpf_bam_split.bam"

samtools sort -o "sorted_cluster_HSCP_ERP1_bam_split.bam" -@ 5 "cluster_HSCP_ERP1_bam_split.bam"
samtools index "sorted_cluster_HSCP_ERP1_bam_split.bam"

samtools sort -o "sorted_cluster_Eosinophils_bam_split.bam" -@ 5 "cluster_Eosinophils_bam_split.bam"
samtools index "sorted_cluster_Eosinophils_bam_split.bam"

samtools sort -o "sorted_cluster_Ebf1+ proB_Hmga2_bam_split.bam" -@ 5 "cluster_Ebf1+ proB_Hmga2_bam_split.bam"
samtools index "sorted_cluster_Ebf1+ proB_Hmga2_bam_split.bam"

samtools sort -o "sorted_cluster_ETP_CC_4_bam_split.bam" -@ 5 "cluster_ETP_CC_4_bam_split.bam"
samtools index "sorted_cluster_ETP_CC_4_bam_split.bam"

samtools sort -o "sorted_cluster_ETP_A_0_bam_split.bam" -@ 5 "cluster_ETP_A_0_bam_split.bam"
samtools index "sorted_cluster_ETP_A_0_bam_split.bam"


# 41-50
samtools sort -o "sorted_cluster_ERP2_bam_split.bam" -@ 5 "cluster_ERP2_bam_split.bam"
samtools index "sorted_cluster_ERP2_bam_split.bam"

samtools sort -o "sorted_cluster_ERP1_bam_split.bam" -@ 5 "cluster_ERP1_bam_split.bam"
samtools index "sorted_cluster_ERP1_bam_split.bam"

samtools sort -o "sorted_cluster_DN4_DP_trans_Hist1h3c_bam_split.bam" -@ 5 "cluster_DN4_DP_trans_Hist1h3c_bam_split.bam"
samtools index "sorted_cluster_DN4_DP_trans_Hist1h3c_bam_split.bam"

samtools sort -o "sorted_cluster_CLP2_bam_split.bam" -@ 5 "cluster_CLP2_bam_split.bam"
samtools index "sorted_cluster_CLP2_bam_split.bam"

samtools sort -o "sorted_cluster_CLP1_Rrm2_bam_split.bam" -@ 5 "cluster_CLP1_Rrm2_bam_split.bam"
samtools index "sorted_cluster_CLP1_Rrm2_bam_split.bam"

samtools sort -o "sorted_cluster_CLP1_Hist1h1c_bam_split.bam" -@ 5 "cluster_CLP1_Hist1h1c_bam_split.bam"
samtools index "sorted_cluster_CLP1_Hist1h1c_bam_split.bam"

samtools sort -o "sorted_cluster_CHILP_bam_split.bam" -@ 5 "cluster_CHILP_bam_split.bam"
samtools index "sorted_cluster_CHILP_bam_split.bam"

samtools sort -o "sorted_cluster_CD127_MP_bam_split.bam" -@ 5 "cluster_CD127_MP_bam_split.bam"
samtools index "sorted_cluster_CD127_MP_bam_split.bam"

samtools sort -o "sorted_cluster_Baso_bam_split.bam" -@ 5 "cluster_Baso_bam_split.bam"
samtools index "sorted_cluster_Baso_bam_split.bam"

samtools sort -o "sorted_cluster_BMCP_bam_split.bam" -@ 5 "cluster_BMCP_bam_split.bam"
samtools index "sorted_cluster_BMCP_bam_split.bam"


EOF
# ./<script_name> | bsub
