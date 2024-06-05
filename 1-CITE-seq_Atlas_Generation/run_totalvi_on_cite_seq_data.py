#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Define libraries to open
import pandas as pd
import numpy as np
import sys
import os
import csv
import gzip
import scipy.io
import anndata
import scvi
import scanpy as sc
import pickle
import torch

sc.settings.verbosity = 1 # verbosity: errors (0), warnings (1), info (2), hints (3)
sc.settings.set_figure_params(dpi=100, fontsize=10, dpi_save=300, figsize=(5,4), format='pdf')


###############################################################################
# Helper Functions
###############################################################################
def load_gene_expression_matrix(matrix_dir):
    features_path = os.path.join(matrix_dir, "features.tsv.gz")
    feature_ids = [row[0] for row in csv.reader(gzip.open(features_path, mode="rt"), delimiter="\t")]
    gene_names = [row[1] for row in csv.reader(gzip.open(features_path, mode="rt"), delimiter="\t")]
    feature_types = [row[2] for row in csv.reader(gzip.open(features_path, mode="rt"), delimiter="\t")]
    barcodes_path = os.path.join(matrix_dir, "barcodes.tsv.gz")
    barcodes = [row[0] for row in csv.reader(gzip.open(barcodes_path, mode="rt"), delimiter="\t")]
    tmp_adata = anndata.read_mtx(os.path.join(matrix_dir, "matrix.mtx.gz")).T
    tmp_adata.obs = pd.DataFrame(index=barcodes)
    tmp_adata.var = pd.DataFrame({"gene": gene_names,
			    "id": feature_ids,
			    "feature_type": feature_types},
			    index=feature_ids)
    return(tmp_adata.copy())

def load_adt_matrix(path_adt_matrix):
    tmp_adt = pd.read_table(path_adt_matrix, index_col=0)
    tmp_adt.columns = pd.Series(tmp_adt.columns)
    return(tmp_adt.copy())

def load_adata_for_cite_seq(matrix_dir, path_adt_matrix, sample_id):
    print("Loading RNA data for {}...".format(sample_id))
    tmp_rna = load_gene_expression_matrix(matrix_dir)
    print("Loading ADT data for {}...".format(sample_id))
    tmp_adt = load_adt_matrix(path_adt_matrix)
    tmp_rna.obs.index = sample_id + "_" + pd.Series(tmp_rna.obs.index)
    tmp_adt.columns = sample_id + "_" + pd.Series(tmp_adt.columns)
    shared_cells = pd.Series(tmp_rna.obs.index)[list(pd.Series(tmp_rna.obs.index).isin(tmp_adt.columns))]
    filtered_adata = tmp_rna[shared_cells,:].copy()
    filtered_adata.obsm['protein_expression'] = tmp_adt.T.loc[shared_cells]
    print("Done.")
    print()
    return(filtered_adata.copy())
    
def combine_adata_objects(list_of_adata_objs):
  adts = pd.Series(list_of_adata_objs[0].obsm._data['protein_expression'].columns)
  for x in list_of_adata_objs:
    adts = adts[adts.isin(pd.Series(x.obsm._data['protein_expression'].columns))]
  for x in list_of_adata_objs:
    x.obsm._data['protein_expression'] = x.obsm._data['protein_expression'][adts]
  adata = list_of_adata_objs[0].concatenate(list_of_adata_objs[1:])
  return(adata.copy())



#### ---RNA Mtx directory paths --- ####
base_path              =   '/Volumes/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT'
ext_AS_3CITE_Kit       =   'AS_3CITE_Kit/AS_3CITE_Kit/outs/filtered_feature_bc_matrix/RNA'
ext_AS_3CITE_Kitx2     =   'AS_3CITE_Kitx2/AS_3CITE_Kitx2/outs/filtered_feature_bc_matrix/RNA'
ext_AS_3CITE_TNC       =   'AS_3CITE_TNC/AS_3CITE_TNC/outs/filtered_feature_bc_matrix/RNA'
ext_AS_CITE_CD127      =   'AS_CITE_CD127/AS_CITE_CD127/outs/filtered_feature_bc_matrix/RNA'
ext_AS_CITE_HSC        =   'AS_CITE_HSC/AS_CITE_HSC/outs/filtered_feature_bc_matrix/RNA'
ext_AS_CITE_Kit        =   'AS_CITE_Kit/AS_CITE_Kit/outs/filtered_feature_bc_matrix/RNA'
ext_AS_CITE_LPAM       =   'AS_CITE_LPAM/AS_CITE_LPAM/outs/filtered_feature_bc_matrix/RNA'
ext_AS_CITE_Multilin1  =   'AS_CITE_Multilin1/AS_CITE_Multilin1/outs/filtered_feature_bc_matrix/RNA'
ext_AS_CITE_Multilin2  =   'AS_CITE_Multilin2/AS_CITE_Multilin2/outs/filtered_feature_bc_matrix/RNA'

### --- # Example of loading corresponding ADT file --- ####
# Example of loading corresponding ADT file
path_adt_files         =    '/Volumes/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/Annie-citeseq-analysis2'

adata_AS_3CITE_Kit     = load_adata_for_cite_seq(matrix_dir = os.path.join(base_path, ext_AS_3CITE_Kit),
					      path_adt_matrix = os.path.join(path_adt_files, 'AS_3CITE_Kit_ADT_clean.txt'),
					      sample_id = 'AS_3CITE_Kit')


adata_AS_3CITE_Kitx2   = load_adata_for_cite_seq(matrix_dir = os.path.join(base_path, ext_AS_3CITE_Kitx2),
					     path_adt_matrix = os.path.join(path_adt_files, 'AS_3CITE_Kitx2_ADT_clean.txt'),
					     sample_id = 'AS_3CITE_Kitx2')


adata_AS_3CITE_TNC     = load_adata_for_cite_seq(matrix_dir = os.path.join(base_path, ext_AS_3CITE_TNC),
					    path_adt_matrix = os.path.join(path_adt_files, 'AS_3CITE_TNC_ADT_clean.txt'),
					    sample_id = 'AS_3CITE_TNC')

adata_AS_CITE_CD127   =  load_adata_for_cite_seq(matrix_dir = os.path.join(base_path, ext_AS_CITE_CD127),
					      path_adt_matrix = os.path.join(path_adt_files, 'AS_CITE_CD127_ADT_clean.txt'),
					      sample_id = 'AS_CITE_CD127')


adata_AS_CITE_HSC    =  load_adata_for_cite_seq(matrix_dir = os.path.join(base_path, ext_AS_CITE_HSC),
					    path_adt_matrix = os.path.join(path_adt_files, 'AS_CITE_HSC_ADT_clean.txt'),
					    sample_id = 'AS_CITE_HSC')



adata_AS_CITE_Kit    =    load_adata_for_cite_seq(matrix_dir = os.path.join(base_path, ext_AS_CITE_Kit ),
					      path_adt_matrix = os.path.join(path_adt_files, 'AS_CITE_Kit_ADT_clean.txt'),
					       sample_id = 'AS_CITE_Kit')

adata_AS_CITE_LPAM    =    load_adata_for_cite_seq(matrix_dir = os.path.join(base_path, ext_AS_CITE_LPAM ),
					      path_adt_matrix = os.path.join(path_adt_files, 'AS_CITE_LPAM_ADT_clean.txt'),
					       sample_id = 'AS_CITE_LPAM')

adata_AS_CITE_Multilin1    =    load_adata_for_cite_seq(matrix_dir = os.path.join(base_path, ext_AS_CITE_Multilin1 ),
					            path_adt_matrix = os.path.join(path_adt_files, 'AS_CITE_Multilin1_ADT_clean.txt'),
					            sample_id = 'AS_CITE_Multilin1')


adata_AS_CITE_Multilin2    =    load_adata_for_cite_seq(matrix_dir = os.path.join(base_path, ext_AS_CITE_Multilin2 ),
					      path_adt_matrix = os.path.join(path_adt_files, 'AS_CITE_Multilin2_ADT_clean.txt'),
					       sample_id = 'AS_CITE_Multilin2')


list_adta_objs =[adata_AS_3CITE_Kit, adata_AS_3CITE_Kitx2, adata_AS_3CITE_TNC ,  adata_AS_CITE_CD127 , adata_AS_CITE_HSC ,adata_AS_CITE_Kit ,
                 adata_AS_CITE_LPAM , adata_AS_CITE_Multilin1 , adata_AS_CITE_Multilin2  ]


print("Combining adata objects...")
adata = combine_adata_objects(list_adta_objs)

print("Normalizing adata object...")
adata.layers["counts"] = adata.X.copy()
sc.pp.normalize_total(adata, target_sum=1e4)
sc.pp.log1p(adata)
adata.raw = adata

print("Finding highly variable genes...")
sc.pp.highly_variable_genes(
  adata,
  n_top_genes=4000,
  flavor="seurat_v3",
  batch_key="batch",
  subset=True,
  layer="counts"
)

print("Setting up anndata object for TOTALVI...")
scvi.data.setup_anndata(
  adata,
  layer="counts",
  batch_key="batch",
  protein_expression_obsm_key="protein_expression"
)

print("Running TOTALVI...")
os.chdir('/Users/khauv3/Desktop/TotalVi-output')
vae = scvi.model.TOTALVI(adata,  latent_distribution="normal")
vae.train(max_epochs =500, train_size=0.9)

print("Adding batch corrected values to adata object...")
adata.obsm["X_totalVI"] = vae.get_latent_representation()
rna, protein = vae.get_normalized_expression(
  n_samples=20,
  return_mean=True,
  transform_batch=["0", "1", "2", "3", "4", "5", "6", "7", "8"]
)

adata.layers["denoised_rna"], adata.obsm["denoised_protein"] = rna, protein

print("Adding protein foreground probability values...")
adata.obsm["protein_foreground_prob"] = vae.get_protein_foreground_probability( 
  n_samples=20,
  return_mean=True,
  transform_batch=["0", "1", "2", "3", "4", "5", "6", "7", "8"]
)

print("Saving adata object...")
pickle_out = open("annie-cite-seq_batch_correction_from_gpu.pickle", "wb")
pickle.dump(adata, pickle_out, protocol=4)
pickle_out.close()
				
# To load the data back into python
os.chdir('/Users/khauv3/Desktop/TotalVi-output')
with open("annie-cite-seq_batch_correction_from_gpu.pickle", "rb") as f:
  adata = pickle.load(f)

sc.pp.neighbors(adata, use_rep="X_totalVI")
sc.tl.umap(adata, min_dist=0.4)
sc.tl.leiden(adata, key_added="leiden_totalVI")
sc.pl.umap(
  adata,
  color=["leiden_totalVI", "batch"],
  frameon=False,
  ncols=1,
  save="umap_plot_totalvi_signal_annie_citeseq_combined.pdf"
)


cell_anno = pd.concat([adata.obs, pd.DataFrame(adata.obsm["X_umap"],
					       columns=["umap_x", "umap_y"],
					       index=adata.obs.index)], axis=1)
cell_anno.to_csv("totalvi_signal_annie_citeseq_combined_cell_annotation.txt", sep="\t", header=True, index=True,
		 index_label="UID")

# Write out the original adt values
adata.obsm["protein_expression"].loc[adata.obs.index].to_csv("totalvi_raw_adt_values_annie_citeseqL.txt", sep="\t",
							     header=True, index=True, index_label="UID")

# Write out the denoised adt values
adata.obsm["denoised_protein"].loc[adata.obs.index].to_csv("totalvi_denoised_adt_values_annie_citeseqL.txt", sep="\t",
							     header=True, index=True, index_label="UID")

# Write out the original RNA values
#raw_rna = pd.DataFrame.sparse.from_spmatrix(adata.layers['counts'], columns=adata.var["gene"], index=adata.obs.index).T
#raw_rna.to_csv("totalvi_raw_rna_count_values_annie_citeseq.txt", sep="\t", header=True, index=True, index_label="UID")

# Write out the denoised RNA values
denoised_rna = pd.DataFrame(adata.layers['denoised_rna'], columns=adata.var["gene"], index=adata.obs.index).T
denoised_rna.to_csv("totalvi_denoised_rna_values_annie_citeseq.txt", sep="\t", header=True, index=True, index_label="UID")


#### adding batch  information  as sample  name for plotting 
sc.settings.verbosity = 1 # verbosity: errors (0), warnings (1), info (2), hints (3) 
sc.settings.set_figure_params(dpi=100, fontsize=10, dpi_save=300, figsize=(5,4), format='png') 

cell_anno['Batch'] = cell_anno['batch']
cell_anno['Batch'].replace({'0':'AS_3CITE_Kit', '1':'AS_3CITE_Kitx2', '2':'AS_3CITE_TNC',  '3' : 'AS_CITE_CD127', 
                            '4' : 'AS_CITE_HSC' , '5' : 'AS_CITE_Kit' , '6' : 'AS_CITE_LPAM' ,
                            '7' : 'AS_CITE_Multilin1', '8':'AS_CITE_Multilin2'},
                            inplace = True)


cell_anno.to_csv("totalvi_signal_annie_citeseq_combined_cell_annotation.txt", sep="\t", header=True, index=True,
		 index_label="UID")

adata.obs['Batch']= cell_anno['Batch']
sc.pl.umap(
  adata,
  color=["leiden_totalVI", "Batch"],
  frameon=False,
  ncols=1,
  save="umap_plot_totalvi_signal_with-dataset-name.pdf"
)

### save as individual plots 
sc.pl.umap(adata, color="leiden_totalVI",legend_loc = 'on data', legend_fontsize =4, save = "clussters-umap.png")

sc.pl.umap(adata, color="Batch", palette='Set2', frameon=False, save = "Batch-corrected-umap-by-dataset-name.png")

