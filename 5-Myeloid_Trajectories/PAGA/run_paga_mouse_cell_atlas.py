import cellrank as cr
import pandas as pd
import scanpy as sc
import scvelo as scv

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

import warnings
from cellrank.kernels import CytoTRACEKernel


cr.settings.verbosity = 2
sc.settings.set_figure_params(frameon=False, dpi=100)

warnings.simplefilter("ignore", category=UserWarning)

# recommend copying the gene exp file to local space to avoid long time in reading file from the network drive
gene_expression = pd.read_csv("/Volumes/salomonis2/LabFiles/Kairavee/Kyle-Annie-HIVE-CITE-ReferenceCreation/CellRank/Mm-CITE-300k-filtered-filtered.txt", sep="\t", index_col="UID", header=0)
groups = pd.read_csv("/Volumes/salomonis2/LabFiles/Kairavee/Kyle-Annie-HIVE-CITE-ReferenceCreation/CellRank/QueryGroups.cellHarmony_titrated-only_level_kt_annotations.txt", sep="\t", header=0,index_col="UID")
gene_expression = gene_expression.loc[:, groups.index]

X = gene_expression.T.values

obs = pd.DataFrame()
obs['cells'] = gene_expression.columns
var_names = gene_expression.index
# dataframe for annotating the variables

var = pd.DataFrame()
var['genes'] = var_names
var.index = var_names

adata = sc.AnnData(X, obs=obs, var=var, dtype="float32")

adata.obs['kt_annotations'] = pd.Categorical(groups['level_kt'])
umap_coords = pd.read_csv("/Volumes/salomonis2/LabFiles/Kairavee/Kyle-Annie-HIVE-CITE-ReferenceCreation/CellRank/UMAP_Coords_CITE_HIVE-titrated_only.txt",sep="\t", index_col="UID",header=0)
umap_coords = umap_coords.loc[groups.index, :]
umap_coords = umap_coords.to_numpy()

adata.obsm['X_umap'] = umap_coords
adata.obs_names = adata.obs['cells']

# Get unique cluster labels
unique_clusters = adata.obs['kt_annotations'].unique()

# Define a color palette for the clusters (you can adjust this based on your preferences)
color_palette = sns.color_palette('Set3', n_colors=len(unique_clusters))
# Create a dictionary to map cluster labels to colors
cluster_colors = {cluster: color for cluster, color in zip(unique_clusters, color_palette)}

# Add a new column to store colors
# adata.obs['colors'] = adata.obs['damien_groups'].map(cluster_colors)
adata.uns['colors'] = cluster_colors

# find highly variable genes amongst the MF genes

sc.pp.highly_variable_genes(adata)

# if you want to set all MF genes as the highly variable genes and not a subset of it as done above, then use the following:
# adata.var['highly_variable'] = True

# calculate neighbors to be able to compute diffusion map (technically not required to use pp.moments, could probably be okay with pp.neighbors)
adata.layers["spliced"] = adata.X
adata.layers["unspliced"] = adata.X
scv.pp.moments(adata, n_pcs=30, n_neighbors=30)

# compute diffusion map
sc.tl.diffmap(adata)

# set a starting point/cell for pseudotime calculation (I used the first HSC cell)
root_ixs = 1  # HSC cell
adata.uns["iroot"] = root_ixs

# compute diffusion pseudotime
sc.tl.dpt(adata)

sc.pl.embedding(
    adata,
    basis="umap",
    color=["dpt_pseudotime","kt_annotations"],
    color_map="gnuplot2",
)
plt.savefig('/Users/tha8tf/CollaborativeProjects/dpt_pseudotime_clean_groups_recreate3.pdf',bbox_inches='tight')
plt.close()

# run paga
adata.uns['velocity_graph'] = adata.obsp['connectivities']
scv.tl.paga(adata, groups='kt_annotations', root_key='HSC', use_time_prior='dpt_pseudotime')

# visualize paga network
scv.pl.paga(adata, threshold=1, show=False, fontsize=2, edge_width_scale=0.1, node_size_scale=0.2, color='dpt_pseudotime', basis='umap', dashed_edges = 'connectivities',solid_edges=None)
plt.savefig('/Users/tha8tf/CollaborativeProjects/paga_network_clean_pseudotime_recreate3.pdf',bbox_inches='tight')
plt.close()

scv.pl.paga(adata, threshold=1, show=False, fontsize=2, edge_width_scale=0.1, node_size_scale=0.2, color='kt_annotations', basis='umap', dashed_edges = 'connectivities',solid_edges=None)
plt.savefig('/Users/tha8tf/CollaborativeProjects/paga_network_clean_groups_recreate3.pdf',bbox_inches='tight')
plt.close()

