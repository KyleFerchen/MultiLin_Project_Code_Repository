#!/data/salomonis2/LabFiles/Frank-Li/citeseq/scanpy_new_env/bin/python3.6
#to run: go to directory of py script, then ./run.py
import scanpy as sc
import anndata as ad
import pandas as pd
import numpy as np
import os,sys
from sklearn.preprocessing import Binarizer
import re

#scTriangulate package already under this directory, simplify import; updates directly reflected
sys.path.insert(0,'/data/salomonis2/software')
from sctriangulate import *
from sctriangulate.preprocessing import *
from sctriangulate.colors import *

#for publication-qualify figure
mpl.rcParams['pdf.fonttype'] = 42
mpl.rcParams['ps.fonttype'] = 42
mpl.rcParams['font.family'] = 'Arial'


'''Step 1: load separate RNA data (after soupx, 15%)'''
# # always first look at the mtx folder
# # see if the file is gz or not
# # for the matrix, look at the first few lines, see if the gene is index or not
# # be slow, print each adata, see its dimension, be responsible
adata_rna_3kit = mtx_to_adata(int_folder='/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_3CITE_Kit/AS_3CITE_Kit/outs/Soupx_Final/soupX-contamination-fraction-0.15/RNA_v3/filtered_RNA_counts',gene_is_index=True,feature='features')  # 9460 × 28692
adata_rna_3kitx2 = mtx_to_adata(int_folder='/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_3CITE_Kitx2/AS_3CITE_Kitx2/outs/SoupX_Final/soupX-contamination-fraction-0.15/RNA_v3/filtered_RNA_counts',gene_is_index=True,feature='features')  # 10095 × 28692
adata_rna_kit = mtx_to_adata(int_folder='/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_CITE_Kit/AS_CITE_Kit/outs/SoupX_Final/soupX-contamination-fraction-0.15/RNA_v3/filtered_RNA_counts',gene_is_index=True,feature='features')  # 11779 × 28692
adata_rna_hsc = mtx_to_adata(int_folder='/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_CITE_HSC/AS_CITE_HSC/outs/SoupX_Final/soupX-contamination-fraction-0.15/RNA_v3/filtered_RNA_counts',gene_is_index=True,feature='features')  # 9356 × 28692
adata_rna_ml1 = mtx_to_adata(int_folder='/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_CITE_Multilin1/AS_CITE_Multilin1/outs/SoupX_Final/soupX-contamination-fraction-0.15/RNA_v3/filtered_RNA_counts',gene_is_index=True,feature='features') # 9309 × 28692
adata_rna_ml2 = mtx_to_adata(int_folder='/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_CITE_Multilin2/AS_CITE_Multilin2/outs/SoupX_Final/soupX-contamination-fraction-0.15/RNA_v3/filtered_RNA_counts',gene_is_index=True,feature='features') # 7979 × 28692
adata_rna_127 = mtx_to_adata(int_folder='/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_CITE_CD127/AS_CITE_CD127/outs/Soupx_Final/soupX-contamination-fraction-0.15/RNA_v3/filtered_RNA_counts',gene_is_index=True,feature='features') # 9842 × 28692


'''data clean, add prefix and suffix based on the adt data'''
adata_rna_3kit.obs_names = ['AS_3CITE_Kit_' + item for item in adata_rna_3kit.obs_names]
adata_rna_3kitx2.obs_names = ['AS_3CITE_Kitx2_' + item for item in adata_rna_3kitx2.obs_names]
adata_rna_127.obs_names = ['AS_CITE_CD127_' + item for item in adata_rna_127.obs_names]
adata_rna_hsc.obs_names = ['AS_CITE_HSC_' + item for item in adata_rna_hsc.obs_names]
adata_rna_kit.obs_names = ['AS_CITE_Kit_' + item for item in adata_rna_kit.obs_names]
adata_rna_ml1.obs_names = ['AS_CITE_ML1_' + item for item in adata_rna_ml1.obs_names]
adata_rna_ml2.obs_names = ['AS_CITE_ML2_' + item for item in adata_rna_ml2.obs_names]

'''step 2: combine all rna capture'''
adata_rna_combined = ad.concat([adata_rna_3kit,adata_rna_3kitx2,adata_rna_kit,adata_rna_hsc,
adata_rna_ml1,adata_rna_ml2,adata_rna_127],axis=0,join='outer',merge='first')  # 67820 × 28692
adata_rna_combined.obs.index.name = None
adata_rna_combined.var.index.name = None
adata_rna_combined.write('adata_rna_combined.h5ad')
adata_rna_combined = sc.read('adata_rna_combined.h5ad')

'''step 3: load combiend adt data (total vi denoised)'''
# look at the file (just first few lines), to see if gene is index or not
adata_adt_processed_combined = small_txt_to_adata(int_file='/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/Annie_Analysis/Annie-citeseq-analysis5/TotalVi-output/totalvi_denoised_adt_values_annie_Transposed_filtered.txt',gene_is_index=True) # 61544 × 112

'''step 4: load raw adt data, clean and combine'''
adata_adt_rna_raw_3kit = sc.read_10x_h5('/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_3CITE_Kit/AS_3CITE_Kit/outs/AS_3CITE_Kit.h5',gex_only=False)   # 11035 × 28804
adata_adt_rna_raw_3kitx2 = sc.read_10x_h5('/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_3CITE_Kitx2/AS_3CITE_Kitx2/outs/AS_3CITE_Kitx2.h5',gex_only=False)  # 11568 × 28804
adata_adt_rna_raw_hsc = sc.read_10x_h5('/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_CITE_HSC/AS_CITE_HSC/outs/AS_CITE_HSC.h5',gex_only=False)  # 9868 ×28804
adata_adt_rna_raw_kit = sc.read_10x_h5('/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_CITE_Kit/AS_CITE_Kit/outs/AS_CITE_Kit.h5',gex_only=False) # 13837 × 28804
adata_adt_rna_raw_ml1 = sc.read_10x_h5('/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_CITE_Multilin1/AS_CITE_Multilin1/outs/AS_CITE_Multilin1.h5',gex_only=False) # 9832 × 28804
adata_adt_rna_raw_ml2 = sc.read_10x_h5('/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_CITE_Multilin2/AS_CITE_Multilin2/outs/AS_CITE_Multilin2.h5',gex_only=False)  # 8936 ×28804
adata_adt_rna_raw_127 = sc.read_10x_h5('/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_CITE_CD127/AS_CITE_CD127/outs/AS_CITE_CD127.h5',gex_only=False)  # 11277 × 28804

'''data clean, make var name unique'''
adata_adt_rna_raw_3kit.var_names_make_unique()
adata_adt_rna_raw_3kitx2.var_names_make_unique()
adata_adt_rna_raw_127.var_names_make_unique()
adata_adt_rna_raw_hsc.var_names_make_unique()
adata_adt_rna_raw_kit.var_names_make_unique()
adata_adt_rna_raw_ml1.var_names_make_unique()
adata_adt_rna_raw_ml2.var_names_make_unique()

'''data clean, add prefix and suffix based on the adt data'''
adata_adt_rna_raw_3kit.obs_names = ['AS_3CITE_Kit_' + item for item in adata_adt_rna_raw_3kit.obs_names]   
adata_adt_rna_raw_3kitx2.obs_names = ['AS_3CITE_Kitx2_' + item for item in adata_adt_rna_raw_3kitx2.obs_names]  
adata_adt_rna_raw_127.obs_names = ['AS_CITE_CD127_' + item for item in adata_adt_rna_raw_127.obs_names]  
adata_adt_rna_raw_hsc.obs_names = ['AS_CITE_HSC_' + item for item in adata_adt_rna_raw_hsc.obs_names]  
adata_adt_rna_raw_kit.obs_names = ['AS_CITE_Kit_' + item for item in adata_adt_rna_raw_kit.obs_names]  
adata_adt_rna_raw_ml1.obs_names = ['AS_CITE_ML1_' + item for item in adata_adt_rna_raw_ml1.obs_names]  
adata_adt_rna_raw_ml2.obs_names = ['AS_CITE_ML2_' + item for item in adata_adt_rna_raw_ml2.obs_names]  
adata_adt_rna_raw = ad.concat([adata_adt_rna_raw_3kit,adata_adt_rna_raw_3kitx2,adata_adt_rna_raw_127,adata_adt_rna_raw_hsc,adata_adt_rna_raw_kit,adata_adt_rna_raw_ml1,adata_adt_rna_raw_ml2],axis=0,join='outer',merge='first')  # 76353 × 28804

'''step 5: common cell barcode and subset'''
cell_from_rna = adata_rna_combined.obs_names
cell_from_adt_processed = adata_adt_processed_combined.obs_names
cell_from_adt_raw = adata_adt_rna_raw.obs_names
common = list(set(cell_from_rna).intersection(set(cell_from_adt_processed)).intersection(set(cell_from_adt_raw)))
whitelist = pd.read_csv('CB_QC_passed_RNA+ADT.txt',sep='\t',index_col=0).index
common = list(set(common).intersection(set(whitelist)))
adata_rna_combined = adata_rna_combined[common,:]  # clean  61543 × 28692
adata_adt_processed_combined = adata_adt_processed_combined[common,:]  # clean 61543 × 112
adata_adt_rna_raw = adata_adt_rna_raw[common,:]   # clean 61543 × 28804

# common gene names
a = adata_rna_adt_raw_combined[:,adata_rna_adt_raw_combined.var['feature_types']=='Gene Expression'].var_names
b = adata_rna_combined.var_names
c_gene = list(set(a).intersection(set(b)))  # 28625

# common adt names
c_adt = adata_rna_adt_raw_combined[:,adata_rna_adt_raw_combined.var['feature_types']=='Antibody Capture'].var_names.tolist()

# make sure they are aligned
adata_rna_adt_processed_combined = adata_rna_adt_processed_combined[common,c_gene+c_adt]  # 61543 × 28737
adata_rna_adt_raw_combined = adata_rna_adt_raw_combined[common,c_gene+c_adt]  # 61543 × 28737

# assembly
adata_rna_adt_final_combined = adata_rna_adt_processed_combined
adata_rna_adt_final_combined.layers['raw_count'] = make_sure_mat_sparse(adata_rna_adt_raw_combined.X)    

# add separate clustering inputs and umap for scTriangulate analysis

### process umap
uc = pd.read_csv('MergedFiles-UMAP_scores-filtered.txt',sep='\t',index_col=0,header=None)
new_index = []
for item in uc.index:
    cb,cap = item.split('.')
    new = cap+'_'+cb
    new = new.replace('Multilin1','ML1')
    new = new.replace('Multilin2','ML2')
    new_index.append(new)
uc.index = new_index
uc.columns= ['umap_x','umap_y']
uc.to_csv('umap_processed.txt',sep='\t')

### process ICGS adt subclustering results
icgs_adt = pd.read_csv('groups.ADT-SubClustered-ICGS-reclass.txt',sep='\t',index_col=0,header=None)
new_index = []
for item in icgs_adt.index:
    cb,cap = item.split('.')
    new = cap+'_'+cb
    new = new.replace('Multilin1','ML1')
    new = new.replace('Multilin2','ML2')
    new_index.append(new)
icgs_adt.index = new_index
icgs_adt.columns = ['label','repeat']
icgs_adt.to_csv('icgs_adt_annotation_processed.txt',sep='\t')

### process ICGS RNA subclustering results
icgs_rna = pd.read_csv('groups.mRNA-SubClustered-ICGS-reclass.txt',sep='\t',index_col=0,header=None)
new_index = []
for item in icgs_rna.index:
    cb,cap = item.split('.')
    new = cap+'_'+cb
    new = new.replace('Multilin1','ML1')
    new = new.replace('Multilin2','ML2')
    new_index.append(new)
icgs_rna.index = new_index
icgs_rna.columns = ['label','repeat']
icgs_rna.to_csv('icgs_rna_annotation_processed.txt',sep='\t')

### process compiled RNA supervised (literature derived) cell annotations
external_rna = pd.read_csv('groups.mRNA-External-Reference-reclass-correct.txt',sep='\t',index_col=0,header=None)
new_index = []
for item in external_rna.index:
    cb,cap = item.split('.')
    new = cap+'_'+cb
    new = new.replace('Multilin1','ML1')
    new = new.replace('Multilin2','ML2')
    new_index.append(new)
external_rna.index = new_index
external_rna.columns = ['label','repeat']
external_rna.to_csv('external_rna_annotation_processed.txt',sep='\t')

add_annotations(adata=adata_rna_adt_final_combined,inputs='external_rna_annotation_processed.txt',cols_input=['label'],index_col=0,cols_output=['External_RNA'],kind='disk')
add_annotations(adata=adata_rna_adt_final_combined,inputs='icgs_rna_annotation_processed.txt',cols_input=['label'],index_col=0,cols_output=['ICGS_RNA'],kind='disk')
add_annotations(adata=adata_rna_adt_final_combined,inputs='icgs_adt_annotation_processed.txt',cols_input=['label'],index_col=0,cols_output=['ICGS_ADT'],kind='disk')
add_umap(adata=adata_rna_adt_final_combined,inputs='umap_processed.txt',mode='pandas_disk',cols=['umap_x','umap_y'],index_col=0)
umap_dual_view_save(adata_rna_adt_final_combined,cols=['External_RNA'])

'''step 6: run scTriangulate'''
sctri = ScTriangulate(dir='./output_two_tfidf_new3',adata=adata_rna_adt_final_combined,query=['External_RNA','ICGS_RNA','ICGS_ADT'],species='mouse')
sctri.lazy_run(layer='raw_count',compute_metrics_parallel=False,scale_sccaf=False,viewer_heterogeneity_keys=['External_RNA','ICGS_RNA','ICGS_ADT'])


'''step7: downstream analysis'''
sctri = ScTriangulate.deserialize('output_two_tfidf_new3/after_pruned_assess.p')

# 1. stability score on umap
for score in ['reassign','SCCAF','tfidf5','tfidf10']:
    sctri.plot_umap(col='{}@pruned'.format(score),kind='continuous',umap_cmap='viridis')

# 2. barplot
sctri.plot_concordance(key1='r6',key2='pruned',style='3dbar')

# 3. annotation
sctri.adata.obs['final_annotation'].to_csv('output_two_tfidf_new3/barcode2final_annotation.txt',sep='\t');sys.exit('stop')
pat = re.compile(r'(AS_3?CITE_.+?)_')
sctri.adata.obs['sample'] = [re.search(pat,item).group(1) for item in sctri.adata.obs_names]
sctri.modality_contributions()
sctri.adata.obs.loc[:,['rna_contribution','adt_contribution','confidence','sample']].to_csv('output_two_tfidf_new3/barcode2metadata.txt',sep='\t')

