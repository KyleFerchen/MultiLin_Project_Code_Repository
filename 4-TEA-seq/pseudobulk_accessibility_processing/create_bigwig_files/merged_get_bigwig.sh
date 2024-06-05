JOB_NAME="get_bw"
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


# Set 1
bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b "/data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_Ebf1+ proB_Hmga2_bam_split.bam" \
-o "Ebf1+ proB_Hmga2.bw"

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_ST_HSC_CC_Mac_1_bam_split.bam \
-o ST_HSC_CC_Mac_1.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MPP4_Hlf_bam_split.bam \
-o MPP4_Hlf.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_LT_HSC_Mllt3_bam_split.bam \
-o LT_HSC_Mllt3.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_HSC_Mac_Fcna_bam_split.bam \
-o HSC_Mac_Fcna.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_pre_MultiLin_2_bam_split.bam \
-o pre_MultiLin_2.bw



# Set 2
bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_pre_MultiLin_1_bam_split.bam \
-o pre_MultiLin_1.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_eHSC_bam_split.bam \
-o eHSC.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_eHSC_Pcna_bam_split.bam \
-o eHSC_Pcna.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_ST_HSC_bam_split.bam \
-o ST_HSC.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MPP5_Flt3_bam_split.bam \
-o MPP5_Flt3.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MPP5_Egr1_bam_split.bam \
-o MPP5_Egr1.bw



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



# Set 6
bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_alphaLP_bam_split.bam \
-o alphaLP.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MultiLin_2_Ms4a3_bam_split.bam \
-o MultiLin_2_Ms4a3.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MultiLin_2_F13a1_bam_split.bam \
-o MultiLin_2_F13a1.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MultiLin_1_preBMCP_bam_split.bam \
-o MultiLin_1_preBMCP.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MultiLin_1_bam_split.bam \
-o MultiLin_1.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MultiLin_1_MEP_bam_split.bam \
-o MultiLin_1_MEP.bw



# Set 7
bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_ML_cell_cycle_bam_split.bam \
-o ML_cell_cycle.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_ML_Mast_bam_split.bam \
-o ML_Mast.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MDP_Irf8_bam_split.bam \
-o MDP_Irf8.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_MDP_Cpa3_bam_split.bam \
-o MDP_Cpa3.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_IG2_proNeu1_bam_split.bam \
-o IG2_proNeu1.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_IG2_MP_bam_split.bam \
-o IG2_MP.bw



# Set 8
bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_Eosinophils_bam_split.bam \
-o Eosinophils.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_ETP_CC_4_bam_split.bam \
-o ETP_CC_4.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_ETP_A_0_bam_split.bam \
-o ETP_A_0.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_ERP2_bam_split.bam \
-o ERP2.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_DN4_DP_trans_Hist1h3c_bam_split.bam \
-o DN4_DP_trans_Hist1h3c.bw



# Set 9
bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_CLP2_bam_split.bam \
-o CLP2.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_CLP1_Rrm2_bam_split.bam \
-o CLP1_Rrm2.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_CLP1_Hist1h1c_bam_split.bam \
-o CLP1_Hist1h1c.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_CHILP_bam_split.bam \
-o CHILP.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_CD127_MP_bam_split.bam \
-o CD127_MP.bw



# Set 10
bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_Baso_bam_split.bam \
-o Baso.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_BMCP_bam_split.bam \
-o BMCP.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_pre_cDC2_bam_split.bam \
-o pre_cDC2.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_cMoP_S100a4_bam_split.bam \
-o cMoP_S100a4.bw

bamCoverage -v --effectiveGenomeSize 2652783500 --normalizeUsing CPM \
-b /data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_merged_bams/merged_sorted_cluster_cMoP_Mki67_bam_split.bam \
-o cMoP_Mki67.bw


EOF