#!/data/salomonis2/LabFiles/Frank-Li/citeseq/scanpy_new_env/bin/python3.6

import scanpy as sc
import anndata as ad
import pandas as pd
import numpy as np
import os,sys
from sklearn.preprocessing import Binarizer
sys.path.insert(0,'/data/salomonis2/LabFiles/Frank-Li/scTriangulate/src_backup')
from sctriangulate import *
from sctriangulate.preprocessing import *
from sctriangulate.colors import *


mpl.rcParams['pdf.fonttype'] = 42
mpl.rcParams['ps.fonttype'] = 42
mpl.rcParams['font.family'] = 'Arial'



# mRNA scaled data, some manipulation
pd.read_csv('./mRNA-scaled/check.txt',sep='\t',index_col=0).T.to_csv('./mRNA-scaled/check_t.txt',sep='\t')
large_txt_to_mtx('./mRNA-scaled/MergedFiles_CPTT-log2.txt','./mRNA-scaled/data',True,'float32')
adata_rna = mtx_to_adata('./mRNA-scaled/data',True)
adata_rna.write('./mRNA-scaled/adata_rna.h5ad')
adata_rna = sc.read('./mRNA-scaled/adata_rna.h5ad')   # 98728 × 41555


# ADT scaled data
adata_adt = small_txt_to_adata('./ADT/exp.r6.txt',True) # 83751 × 112
adata_adt.write('./ADT/adata_adt.h5ad')
adata_adt = sc.read('./ADT/adata_adt.h5ad')
adata_adt.obs_names = [item.replace('-','.') for item in adata_adt.obs_names]


# analyze h5 file
adata_3kit = sc.read_10x_h5('./mRNA-ADT-counts/AS_3CITE_Kit.h5',gex_only=False) # 11035 × 28804
adata_3kit.obs_names = ['AS_3CITE_Kit_' + item.replace('-','.') for item in adata_3kit.obs_names]
adata_3kit.var_names = ['AB_{}'.format(n) if t == 'Antibody Capture' else n for n,t in  zip(adata_3kit.var['feature_types'].index,adata_3kit.var['feature_types'].values)]
adata_3kit.var_names_make_unique()

adata_3kitx2 = sc.read_10x_h5('./mRNA-ADT-counts/AS_3CITE_Kitx2.h5',gex_only=False) # 11568 × 28804
adata_3kitx2.obs_names = ['AS_3CITE_Kitx2_' + item.replace('-','.') for item in adata_3kitx2.obs_names]
adata_3kitx2.var_names = ['AB_{}'.format(n) if t == 'Antibody Capture' else n for n,t in  zip(adata_3kitx2.var['feature_types'].index,adata_3kitx2.var['feature_types'].values)]
adata_3kitx2.var_names_make_unique()

adata_3tnc = sc.read_10x_h5('./mRNA-ADT-counts/AS_3CITE_TNC.h5',gex_only=False)  # 8532 × 28804
adata_3tnc.obs_names = ['AS_3CITE_TNC_' + item.replace('-','.') for item in adata_3tnc.obs_names]
adata_3tnc.var_names = ['AB_{}'.format(n) if t == 'Antibody Capture' else n for n,t in  zip(adata_3tnc.var['feature_types'].index,adata_3tnc.var['feature_types'].values)]
adata_3tnc.var_names_make_unique()

adata_cd127 = sc.read_10x_h5('./mRNA-ADT-counts/AS_CITE_CD127.h5',gex_only=False)  # 11277 × 28804
adata_cd127.obs_names = ['AS_CITE_CD127_' + item.replace('-','.') for item in adata_cd127.obs_names]
adata_cd127.var_names = ['AB_{}'.format(n) if t == 'Antibody Capture' else n for n,t in  zip(adata_cd127.var['feature_types'].index,adata_cd127.var['feature_types'].values)]
adata_cd127.var_names_make_unique()

adata_hsc = sc.read_10x_h5('./mRNA-ADT-counts/AS_CITE_HSC.h5',gex_only=False) # 9868 × 28804
adata_hsc.obs_names = ['AS_CITE_HSC_' + item.replace('-','.') for item in adata_hsc.obs_names]
adata_hsc.var_names = ['AB_{}'.format(n) if t == 'Antibody Capture' else n for n,t in  zip(adata_hsc.var['feature_types'].index,adata_hsc.var['feature_types'].values)]
adata_hsc.var_names_make_unique()

adata_kit = sc.read_10x_h5('./mRNA-ADT-counts/AS_CITE_Kit.h5',gex_only=False)  # 13837 × 28804
adata_kit.obs_names = ['AS_CITE_Kit_' + item.replace('-','.') for item in adata_kit.obs_names]
adata_kit.var_names = ['AB_{}'.format(n) if t == 'Antibody Capture' else n for n,t in  zip(adata_kit.var['feature_types'].index,adata_kit.var['feature_types'].values)]
adata_kit.var_names_make_unique()

adata_lpam = sc.read_10x_h5('./mRNA-ADT-counts/AS_CITE_LPAM.h5',gex_only=False)  # 11293 × 28804
adata_lpam.obs_names = ['AS_CITE_LPAM_' + item.replace('-','.') for item in adata_lpam.obs_names]
adata_lpam.var_names = ['AB_{}'.format(n) if t == 'Antibody Capture' else n for n,t in  zip(adata_lpam.var['feature_types'].index,adata_lpam.var['feature_types'].values)]
adata_lpam.var_names_make_unique()

adata_multilin1 = sc.read_10x_h5('./mRNA-ADT-counts/AS_CITE_Multilin1.h5',gex_only=False) # 9832 × 28804
adata_multilin1.obs_names = ['AS_CITE_Multilin1_' + item.replace('-','.') for item in adata_multilin1.obs_names]
adata_multilin1.var_names = ['AB_{}'.format(n) if t == 'Antibody Capture' else n for n,t in  zip(adata_multilin1.var['feature_types'].index,adata_multilin1.var['feature_types'].values)]
adata_multilin1.var_names_make_unique()

adata_multilin2 = sc.read_10x_h5('./mRNA-ADT-counts/AS_CITE_Multilin2.h5',gex_only=False) # 8936 × 28804
adata_multilin2.obs_names = ['AS_CITE_Multilin2_' + item.replace('-','.') for item in adata_multilin2.obs_names]
adata_multilin2.var_names = ['AB_{}'.format(n) if t == 'Antibody Capture' else n for n,t in  zip(adata_multilin2.var['feature_types'].index,adata_multilin2.var['feature_types'].values)]
adata_multilin2.var_names_make_unique()

adata_raw_count = ad.concat([adata_3kit,adata_3kitx2,adata_3tnc,adata_cd127,adata_hsc,adata_kit,adata_lpam,adata_multilin1,adata_multilin2],
                             axis=0,merge='first',join='inner')
'''
96178 × 28804
Gene Expression     28692
Antibody Capture      112
'''


# find common cells
ch_annotation = pd.read_csv('./Clusters/groups.r6.txt',sep='\t',index_col=0)
ch_annotation.index = [item.replace('-','.') for item in ch_annotation.index]
umap_coords = pd.read_csv('./UMAP/UMAP_scores.txt',sep='\t',index_col=0)
umap_coords.index = [item[:-2] for item in umap_coords.index]

common = list(set(adata_rna.obs_names).intersection(set(adata_adt.obs_names)).intersection(set(adata_raw_count.obs_names)).
         intersection(set(ch_annotation.index)).intersection(set(umap_coords.index)))


# now subset eveything
adata_rna = adata_rna[common,:]
adata_adt = adata_adt[common,:]
adata_raw_count = adata_raw_count[common,:]
ch_annotation = ch_annotation.loc[common,:]
umap_coords = umap_coords.loc[common,:]


adata_raw_count_rna = adata_raw_count[:,adata_raw_count.var['feature_types']=='Gene Expression']
adata_raw_count_adt = adata_raw_count[:,adata_raw_count.var['feature_types']=='Antibody Capture']

print(adata_raw_count_rna)
print(adata_raw_count_adt)
adata_raw_count_rna.write('to_seurat_adata_rna.h5ad')
adata_raw_count_adt.write('to_seurat_adata_adt.h5ad')
# sys.exit('stop')

# analysis
# add_annotations(adata_rna,ch_annotation,cols_input=['label'],cols_output=['cellHarmony'],kind='memory')
# add_umap(adata_rna,umap_coords,'pandas_memory',['umap_x','umap_y'])
# adata_rna = scanpy_recipe(adata_rna,True,resolutions=[0.5,1,2,3,4,5],modality='rna',umap=False,pca_n_comps=50,n_top_genes=3000,species='mouse')
adata_rna = sc.read('adata_after_scanpy_recipe_rna_0.5_1_2_3_4_5_umap_False.h5ad')
# cols = ['sctri_rna_leiden_{}'.format(r) for r in [0.5,1,2,3,4,5]] + ['cellHarmony']
# umap_dual_view_save(adata_rna,cols)

# add_annotations(adata_adt,ch_annotation,cols_input=['label'],cols_output=['cellHarmony'],kind='memory')
# add_umap(adata_adt,umap_coords,'pandas_memory',['umap_x','umap_y'])
# adata_adt = scanpy_recipe(adata_adt,True,resolutions=[0.5,1,2,3,4,5],modality='adt',umap=False,pca_n_comps=15)
adata_adt = sc.read('adata_after_scanpy_recipe_adt_0.5_1_2_3_4_5_umap_False.h5ad')
# cols = ['sctri_adt_leiden_{}'.format(r) for r in [0.5,1,2,3,4,5]]
# umap_dual_view_save(adata_adt,cols)

adata_combine = concat_rna_and_other(adata_rna,adata_adt,'rna','ADT','AB_')  # 83526 × 41667
common = list(set(adata_combine.var_names).intersection(set(adata_raw_count.var_names)))
adata_combine = adata_combine[:,common]
adata_raw_count = adata_raw_count[adata_combine.obs_names,common]

'''
83526 × 25721
Gene Expression     25609
Antibody Capture      112
'''

# run scTriangulate
adata = adata_combine
adata.layers['raw_count'] = make_sure_mat_sparse(adata_raw_count.X)

# Run with one tfidf
sctri = ScTriangulate(dir='./output_one',adata=adata,query=['cellHarmony','sctri_rna_leiden_5','sctri_adt_leiden_4'],add_metrics={},species='mouse')
sctri.lazy_run(compute_metrics_parallel=False,scale_sccaf=False,layer='raw_count')
sctri = ScTriangulate.deserialize('output_one/after_pruned_assess.p')
sctri.adata.obs['pruned'].to_csv('output_one/barcode2pruned.txt',sep='\t')
sctri.gene_to_df(mode='marker_genes',key='pruned')
sctri.gene_to_df(mode='exclusive_genes',key='pruned')
sctri.adata.write('output_one/to_cellxgene.h5ad')
sctri.display_hierarchy(ref_col='pruned',query_col='cellHarmony')
adata = sctri.adata
adata_s = adata[adata.obs['pruned']=='sctri_adt_leiden_4@30',:]
custom_two_column_sankey(adata_s,'pruned','cellHarmony',text=True,outdir='output_one')
sctri.plot_long_heatmap(figsize=(6,4.8),feature_fontsize=1,cluster_fontsize=1,n_features=5,heatmap_regex=r'^AB_',heatmap_direction='include')




# Run with two tfidf
sctri = ScTriangulate(dir='./output_two',adata=adata,query=['cellHarmony','sctri_rna_leiden_5','sctri_adt_leiden_4'],species='mouse')
sctri.lazy_run(compute_metrics_parallel=False,scale_sccaf=False,layer='raw_count')
sctri = ScTriangulate.deserialize('output_two/after_pruned_assess.p')
sctri.adata.write('output_two/to_cellxgene.h5ad')
sctri.adata.obs['pruned'].to_csv('output_two/barcode2pruned.txt',sep='\t')
sctri.gene_to_df(mode='marker_genes',key='pruned')
sctri.gene_to_df(mode='exclusive_genes',key='pruned')
umap_color_exceed_102(sctri.adata,'pruned',outdir='output_two')

sctri = ScTriangulate.deserialize('output_two/after_pruned_assess.p')
sctri.modality_contributions()
sctri.adata.obs.to_csv('output_two/sctri2metadata.txt',sep='\t')


















