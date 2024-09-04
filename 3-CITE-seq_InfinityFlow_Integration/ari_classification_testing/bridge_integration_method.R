
library(Matrix)
library(Seurat)
library(ggplot2)

setwd("/media/kyle_storage/kyle_ferchen/grimes_lab_main/analysis/2024_08_27_work_on_redoing_bridge_integration_ari_dataset")

path_output_results_table <- "output/result-Seurat_scaled-raw_counts_CLR_scaled.csv"
cite_adt_values_file <- "CITE-seq_RNA_supervised_gate_labels-ADT_counts.csv"
infinityflow_values_file <- "InfinityFlow_gated_cells-logicle_normalized.csv"
do.scale.parameter <- TRUE

# Read in the ADT counts
path_to_cite_counts <- paste0(
  "/home/kyle/Documents/MultiLin_Paper_Data/Processed_Data/",
  "InfinityFlow_CITE-seq_Integration/data/unified/"
)

# The path to the gene counts sparse matrix and supplementary files
path_to_rna_counts <- paste0(
  "/media/kyle_storage/kyle_ferchen/grimes_lab_main/analysis/",
  "2024_08_27_work_on_redoing_bridge_integration_ari_dataset/input/",
  "cite_gene_data_for_ari_testing/"
)

# Map feature names between CITE-seq and InfinityFlow
map_feature_names <- read.csv(file.path(
  path_to_cite_counts,
  "feature_linkages.csv"
))

################################################################################
# Prepare Input Data
################################################################################
### Read in the count data
# Read in the mtx for gene expression data
gene_counts <- readMM(file.path(path_to_rna_counts, "matrix.mtx"))

# Read in the cell names (observerations)
obs_anno <- read.csv(file.path(path_to_rna_counts, "observations.csv"))
obs_anno <- data.frame(obs_anno, row.names=1)

# Read in the gene feature names (variables)
var_anno <- read.csv(file.path(path_to_rna_counts, "features.csv"))
var_anno <- data.frame(var_anno, row.names=1)

# Attach names to matrix
rownames(gene_counts) <- row.names(obs_anno)
colnames(gene_counts) <- row.names(var_anno)


### ADT values from CITE-seq
cite_adt_values <- read.csv(file.path(
  path_to_cite_counts,
  cite_adt_values_file
))
cite_adt_values <- data.frame(cite_adt_values, row.names=1)


### Create Seurat objects for bridge integration
obj.multi <- CreateSeuratObject(
  counts = t(gene_counts[rownames(cite_adt_values),]),
  assay = "RNA",
  meta.data = obs_anno)

# Create a new assay to store ADT information
# # For raw adt counts
# adt_assay <- CreateAssay5Object(counts = t(adt_counts))
# For KDE mapped distribution ADT values
adt_assay <- CreateAssay5Object(
  counts = t(cite_adt_values)
)

obj.multi[["ADT"]] <- adt_assay

# Confirm the object now contains multiple assays
Assays(obj.multi)

# Separate out the RNA from CITE-seq as the reference data
obj.rna <- CreateSeuratObject(
  counts = t(gene_counts[rownames(cite_adt_values),]),
  assay = "RNA",
  meta.data = obs_anno)


### Read in the flow data
inflow_data <- read.csv(file.path(
  path_to_cite_counts,
  infinityflow_values_file
))
inflow_data <- data.frame(inflow_data, row.names=1)


# Read in map for inflow feature names to cite-seq feature names
inflow_rename_data <- data.frame(
  inflow_data[,gsub("-", ".", map_feature_names$Channel)])
colnames(inflow_rename_data) <- map_feature_names$OPTI_ADT

obj.flow <- CreateSeuratObject(
  counts = t(inflow_rename_data[,1:91]),
  assay = "ADT")




################################################################################
# Apply Normalizations
################################################################################

## Bridge dataset RNA
DefaultAssay(obj.multi) <- "RNA"
# Perform visualization and clustering steps
obj.multi <- NormalizeData(obj.multi)
obj.multi <- FindVariableFeatures(obj.multi)
obj.multi <- ScaleData(obj.multi)
obj.multi <- RunPCA(obj.multi, verbose = FALSE)
obj.multi <- FindNeighbors(obj.multi, dims = 1:30)
obj.multi <- FindClusters(obj.multi, resolution = 0.8, verbose = FALSE)
obj.multi <- RunUMAP(obj.multi, dims = 1:30)

## Reference dataset RNA
obj.rna <- NormalizeData(obj.rna)
obj.rna <- FindVariableFeatures(obj.rna)
obj.rna <- ScaleData(obj.rna)
obj.rna <- RunPCA(obj.rna, verbose = FALSE)
obj.rna <- FindNeighbors(obj.rna, dims = 1:30)
obj.rna <- RunUMAP(obj.rna, dims = 1:30)


## Normalize ADT values for CITE-seq
DefaultAssay(obj.multi) <- "ADT"
obj.multi <- NormalizeData(
  obj.multi,
  normalization.method = "CLR")

# Set scaled ADT data
obj.flow@assays$ADT$data <- obj.flow@assays$ADT$counts


# Align matched features
DefaultAssay(obj.multi) <- 'ADT'
adt.feature <- intersect(rownames(obj.multi[['ADT']]), rownames(obj.flow))
VariableFeatures(obj.multi) <- adt.feature

obj.multi <- ScaleData(obj.multi, features = adt.feature, do.scale = do.scale.parameter)
obj.flow <- ScaleData(obj.flow, features = adt.feature, do.scale = do.scale.parameter)




################################################################################
# Bridge Integration
################################################################################



# Prepare the bridge integration extended reference
dims.adt <- 1:20
dims.rna <- 1:30

DefaultAssay(obj.multi) <- 'RNA'
ref.extend <- PrepareBridgeReference(
  reference = obj.rna,
  normalization.method = 'LogNormalize',
  bridge = obj.multi,
  reference.reduction = 'pca',
  reference.dims = dims.rna,
  bridge.query.assay = 'ADT',
  supervised.reduction = 'spca',
  bridge.query.features = adt.feature
)



anchor <- FindBridgeTransferAnchors(
  extended.reference = ref.extend,
  query = obj.flow,
  reduction = 'pcaproject',
  scale = do.scale.parameter,
  dims = dims.adt
)


obj.flow <- MapQuery(
  anchorset = anchor,
  reference = ref.extend,
  query = obj.flow,
  refdata = "rna_classified_group"
)


write.csv(obj.flow@meta.data, path_output_results_table, row.names=FALSE)