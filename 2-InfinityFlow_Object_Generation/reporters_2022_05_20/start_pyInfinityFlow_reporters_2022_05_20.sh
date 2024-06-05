
DIR=$(pwd)

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 24:00
#BSUB -n 12
#BSUB -R "span[ptile=4]"
#BSUB -M 80000
#BSUB -e $DIR/logs/%J.err
#BSUB -o $DIR/logs/%J.out

cd $DIR

# module load anaconda3
# conda activate /data/salomonis2/LabFiles/Kyle/Env/pyInfinityFlow_dev


pyInfinityFlow --data_dir /data/salomonis2/LabFiles/Kyle/Analysis/2022_07_01_Infinity_Flow_Update/input/gated_live_fcs_input/2022_05_20_PE \
--out_dir /data/salomonis2/LabFiles/Kyle/Analysis/2022_10_26_pyInfinityFlow_grimes_data/outputs/pyInfinityFlow_outputs/reporters_2022_05_20/ \
--backbone_annotation /data/salomonis2/LabFiles/Kyle/Analysis/2022_07_01_Infinity_Flow_Update/input/pyInfinityFlow_annotations/2021_12_13_Reporter_backbone_anno.csv \
--infinity_marker_annotation /data/salomonis2/LabFiles/Kyle/Analysis/2022_07_01_Infinity_Flow_Update/input/pyInfinityFlow_annotations/2022_05_20_reporters_infinity_marker_anno.csv \
--random_state 7 \
--use_logicle_scaling True \
--normalization_method None \
--n_events_train 0 \
--n_events_validate 0 \
--ratio_for_validation 0.2 \
--separate_backbone_reference /data/salomonis2/LabFiles/Kyle/Analysis/2022_07_01_Infinity_Flow_Update/input/gated_live_fcs_input/2022_06_28_PE/export_KF_Infinity_Flow_Add_PEs-Infinity_Markers_PE-CD131_Unmixed_Live.fcs \
--add_umap False \
--find_clusters False \
--find_markers False \
--make_feature_plots False \
--use_pca True \
--n_pc 15 \
--n_pc_plot_qc 50 \
--save_h5ad True \
--save_feather True \
--save_file_handler True \
--save_regression_models True \
--verbosity 3 \
--n_cores 12


EOF

# ./<file_name> | bsub

