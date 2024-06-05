import scanpy as sc
import numpy as np
import pandas as pd
import os
import pickle

os.chdir("/media/kyle_storage/kyle_ferchen/grimes_lab_main/analysis/2022_01_11_mouse_tea_seq_atac/")


with open("input/sctriangulate/output_two/AS_TEAr_ML1/after_pruned_assess.p",'rb') as f:
            sctri_ml1 = pickle.load(f)

barcode_to_cluster_ml1 = sctri_ml1.adata.obs['pruned']
del sctri_ml1

with open("input/sctriangulate/output_two/AS_TEAr_ML2/after_pruned_assess.p",'rb') as f:
            sctri_ml2 = pickle.load(f)

barcode_to_cluster_ml2 = sctri_ml2.adata.obs['pruned']
del sctri_ml2

with open("input/sctriangulate/output_two/AS_TEAr_H1/after_pruned_assess.p",'rb') as f:
            sctri_h1 = pickle.load(f)

barcode_to_cluster_h1 = sctri_h1.adata.obs['pruned']
del sctri_h1

with open("input/sctriangulate/output_two/AS_TEAr_H2/after_pruned_assess.p",'rb') as f:
            sctri_h2 = pickle.load(f)

barcode_to_cluster_h2 = sctri_h2.adata.obs['pruned']
del sctri_h2






pd.DataFrame({"barcode": barcode_to_cluster_ml1.index.values,
                "cluster": barcode_to_cluster_ml1.values}).to_csv("input/sctriangulate/barcode_to_cluster_files/AS_TEAr_ML1_barcodes_to_sctri_clusters.txt",
                                                                    sep="\t", header=True, index=False)

pd.DataFrame({"barcode": barcode_to_cluster_ml2.index.values,
                "cluster": barcode_to_cluster_ml2.values}).to_csv("input/sctriangulate/barcode_to_cluster_files/AS_TEAr_ML2_barcodes_to_sctri_clusters.txt",
                                                                    sep="\t", header=True, index=False)

pd.DataFrame({"barcode": barcode_to_cluster_h1.index.values,
                "cluster": barcode_to_cluster_h1.values}).to_csv("input/sctriangulate/barcode_to_cluster_files/AS_TEAr_H1_barcodes_to_sctri_clusters.txt",
                                                                    sep="\t", header=True, index=False)

pd.DataFrame({"barcode": barcode_to_cluster_h2.index.values,
                "cluster": barcode_to_cluster_h2.values}).to_csv("input/sctriangulate/barcode_to_cluster_files/AS_TEAr_H2_barcodes_to_sctri_clusters.txt",
                                                                    sep="\t", header=True, index=False)
