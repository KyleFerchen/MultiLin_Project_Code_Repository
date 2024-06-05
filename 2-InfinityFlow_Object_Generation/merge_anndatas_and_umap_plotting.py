
import os
import scanpy as sc
import pandas as pd
import numpy as np
import anndata

from pyInfinityFlow.InfinityFlow_Utilities import apply_logicle_to_anndata
from pyInfinityFlow.InfinityFlow_Utilities import move_features_out_of_silent
from pyInfinityFlow.InfinityFlow_Utilities import move_features_to_silent
from pyInfinityFlow.InfinityFlow_Utilities import anndata_to_df
from pyInfinityFlow.Plotting_Utilities import plot_feature_over_x_y_coordinates_and_save_fig


path_outputs = "/data/salomonis2/LabFiles/Kyle/Analysis/"\
    "2022_10_26_pyInfinityFlow_grimes_data/outputs/pyInfinityFlow_outputs/"

fix_cd115 = sc.read_h5ad(os.path.join(path_outputs,
    "fix_cd115_2022_06_28/regression_results/infinity_flow_object_logicle_normalized.h5ad"))
ms4a3cre = sc.read_h5ad(os.path.join(path_outputs,
    "ms4a3cre_2022_07_01/regression_results/infinity_flow_object_logicle_normalized.h5ad"))
pe_2021_12_13 = sc.read_h5ad(os.path.join(path_outputs,
    "pe_2021_12_13/regression_results/infinity_flow_object_logicle_normalized.h5ad"))
pe_2022_01_19 = sc.read_h5ad(os.path.join(path_outputs,
    "pe_2022_01_19/regression_results/infinity_flow_object_logicle_normalized.h5ad"))
pe_2022_05_20 = sc.read_h5ad(os.path.join(path_outputs,
    "pe_2022_05_20/regression_results/infinity_flow_object_logicle_normalized.h5ad"))
pe_2022_06_28 = sc.read_h5ad(os.path.join(path_outputs,
    "pe_2022_06_28/regression_results/infinity_flow_object_logicle_normalized.h5ad"))
reporters_2021_12_13 = sc.read_h5ad(os.path.join(path_outputs,
    "reporters_2021_12_13/regression_results/infinity_flow_object_logicle_normalized.h5ad"))
reporters_2022_01_19 = sc.read_h5ad(os.path.join(path_outputs,
    "reporters_2022_01_19/regression_results/infinity_flow_object_logicle_normalized.h5ad"))
reporters_2022_05_20 = sc.read_h5ad(os.path.join(path_outputs,
    "reporters_2022_05_20/regression_results/infinity_flow_object_logicle_normalized.h5ad"))


list_adata = [fix_cd115,
    ms4a3cre,
    pe_2021_12_13,
    pe_2022_01_19,
    pe_2022_05_20,
    pe_2022_06_28,
    reporters_2021_12_13,
    reporters_2022_01_19,
    reporters_2022_05_20]

unique_features = []
features_to_use = []
for item in list_adata:
    check = ~pd.Series(item.var.index.values).isin(unique_features).values
    unique_features += list(item.var.index.values[check])
    features_to_use.append(item.var.index.values[check])

cells = pd.Series(list_adata[0].obs.index.values).sample(200000).values
new_X = np.concatenate([list_adata[0][cells, features_to_use[0]].X.toarray(),
    list_adata[1][cells, features_to_use[1]].X.toarray(),
    list_adata[2][cells, features_to_use[2]].X.toarray(),
    list_adata[3][cells, features_to_use[3]].X.toarray(),
    list_adata[4][cells, features_to_use[4]].X.toarray(),
    list_adata[5][cells, features_to_use[5]].X.toarray(),
    list_adata[6][cells, features_to_use[6]].X.toarray(),
    list_adata[7][cells, features_to_use[7]].X.toarray(),
    list_adata[8][cells, features_to_use[8]].X.toarray()], axis=1)

new_obs = list_adata[0][cells, features_to_use[0]].obs.copy()
new_var = pd.concat([list_adata[0][cells, features_to_use[0]].var,
    list_adata[1][cells, features_to_use[1]].var,
    list_adata[2][cells, features_to_use[2]].var,
    list_adata[3][cells, features_to_use[3]].var,
    list_adata[4][cells, features_to_use[4]].var,
    list_adata[5][cells, features_to_use[5]].var,
    list_adata[6][cells, features_to_use[6]].var,
    list_adata[7][cells, features_to_use[7]].var,
    list_adata[8][cells, features_to_use[8]].var])

sub_p_adata = anndata.AnnData(X=new_X, obs=new_obs, var=new_var)

apply_logicle_to_anndata(sub_p_adata)

features_to_hide = ['AF-A', 'FSC-A', 'FSC-H', 'FSC-W', 
    'LIVEDEADBlue-A', 'SSC-A', 'SSC-B-A', 'SSC-B-H', 
    'SSC-B-W', 'SSC-H', 'SSC-W', 'Time']

sub_p_adata = move_features_to_silent(sub_p_adata, features_to_hide)

use_pca = True
# Perform PCA, if necessary
if use_pca:
    sc.tl.pca(sub_p_adata)
    sub_p_adata.uns['pca_features'] = sub_p_adata.var.index.values


sc.pp.neighbors(sub_p_adata, n_pcs=15)
sc.tl.umap(sub_p_adata)
sub_p_adata.obs["umap-x"] = sub_p_adata.obsm['X_umap'][:,0]
sub_p_adata.obs["umap-y"] = sub_p_adata.obsm['X_umap'][:,1]

print(f"DEBUG: add_umap value: {add_umap}")
print(f"DEBUG: find_clusters value: {find_clusters}")
print(f"DEBUG: find_markers value: {find_markers}")
print(f"DEBUG: make_feature_plots value: {make_feature_plots}")



# Save the umap figures
if make_feature_plots:
    timings_6 = save_umap_figures_all_features(sub_p_adata, 
        background_corrected_data = background_corrected_data, 
        file_handler = file_handler, 
        output_paths = output_paths, 
        verbosity=VERBOSITY)
else:
    timings_6 = {}





def save_umap_figures_all_features(sub_p_adata, background_corrected_data, file_handler, 
        output_paths, verbosity=0):


output_path = "/data/salomonis2/LabFiles/Kyle/Analysis/2022_10_26_pyInfinityFlow_grimes_data/outputs/umap_plots/"
map_feature_to_name = {}
map_feature_to_filepath = {}
for tmp_feature in sub_p_adata.var.index.values:
    print(f"Working on plotting feature {tmp_feature}...")
    if sub_p_adata.var.loc[tmp_feature, "IMPUTED"]:
        tmp_output_name = sub_p_adata.var.loc[tmp_feature, "name"]
    else:
        if len(sub_p_adata.var.loc[tmp_feature, "name"]) > 0:
            tmp_output_name = f'{tmp_feature}_{sub_p_adata.var.loc[tmp_feature, "name"]}'
        else:
            tmp_output_name = tmp_feature
    map_feature_to_name[tmp_feature] = tmp_output_name
    map_feature_to_filepath[tmp_feature] = os.path.join(output_path, 
        f'{tmp_output_name.replace("/", "-")}_feature_plot.png')
    
anndata_to_df(sub_p_adata).apply(lambda x: plot_feature_over_x_y_coordinates_and_save_fig(\
    feature_vector = x.values, x = sub_p_adata.obs['umap-x'].values, 
    y = sub_p_adata.obs['umap-y'].values, feature_name = map_feature_to_name[x.name], 
    file_path = map_feature_to_filepath[x.name]))



