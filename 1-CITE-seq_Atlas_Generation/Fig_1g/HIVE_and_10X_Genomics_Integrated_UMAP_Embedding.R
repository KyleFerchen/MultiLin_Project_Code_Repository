library(Seurat)
library(ggplot2)

setwd("/data/salomonis2/LabFiles/Kairavee/Kyle-Annie-HIVE-CITE-ReferenceCreation/")
dir.create("VariableFeaturesByNS_ForBothHIVE_CITE")
setwd("/data/salomonis2/LabFiles/Kairavee/Kyle-Annie-HIVE-CITE-ReferenceCreation/VariableFeaturesByNS_ForBothHIVE_CITE/")

## read in the variable genes provided by NS
genes_ns = read.table("/data/salomonis2/LabFiles/Kairavee/Kyle-Annie-HIVE-CITE-ReferenceCreation/variablegenes_NS.txt",sep = "\t",header = F,stringsAsFactors = F)


## load in CPTT file 1
cite_cptt = as.matrix(read.table(file = "/data/salomonis2/LabFiles/Kairavee/Kyle-Annie-HIVE-CITE-ReferenceCreation/Mm-CITE-300k-filtered-_noAML_noThymus_KT-filtered.txt", sep = "\t", header = T, row.names = 1, check.names = F))
CITE <- CreateSeuratObject(cite_cptt, min.cells = 0, project= 'CITE-Mm') 
CITE$ident <- "CITE-Mm"
CITE[["percent.mt"]] <- PercentageFeatureSet(CITE, pattern = "^MT-")
#VlnPlot(CITE, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)
#ggsave('CITE_QC_Stats_Seuratv3.png')


VariableFeatures(CITE) <- rownames(cite_cptt)


## load in CPTT file 2
hive_cptt = as.matrix(read.table(file = "/data/salomonis2/LabFiles/Kairavee/Kyle-Annie-HIVE-CITE-ReferenceCreation/exp.HIVE-OutliersRemoved-filtered.txt", sep = "\t", header = T, row.names = 1, check.names = F))
HIVE <- CreateSeuratObject(hive_cptt, min.cells = 0, project= 'HIVE-Mm') 
HIVE$ident <- "HIVE-Mm"
HIVE[["percent.mt"]] <- PercentageFeatureSet(HIVE, pattern = "^MT-")
VlnPlot(HIVE, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)
ggsave('HIVE_QC_Stats_Seuratv3.png')

VariableFeatures(HIVE) <- rownames(hive_cptt)


## Integrate the data 
IntList <- list(CITE, HIVE)

CITE_HIVE.anchors <- FindIntegrationAnchors(object.list = IntList, dims = 1:50 , anchor.features =2000)
CITE_HIVE.combined <- IntegrateData(anchorset = CITE_HIVE.anchors, dims = 1:50)

DefaultAssay(CITE_HIVE.combined) <- "integrated"


# # Run the standard workflow for visualization and clustering
CITE_HIVE.combined <- ScaleData(CITE_HIVE.combined, verbose = FALSE)
CITE_HIVE.combined <- RunPCA(CITE_HIVE.combined, npcs = 50, verbose = FALSE)


# run elbow plot here: evaluate dims for neighboring  and clustering
png("PCE-bowl-plot.png", width = 8, height = 15, units = 'in', res = 600)
pdf("PCE-bowl-plot.pdf", width = 8, height = 15)
ElbowPlot(CITE_HIVE.combined, ndims= 50, reduction = 'pca')
dev.off()

CITE_HIVE.combined <- RunUMAP(CITE_HIVE.combined, reduction = "pca", dims = 1:30)

saveRDS(CITE_HIVE.combined, file = 'SeuratIntegratedObject.rds')  
save.image('SeuratIntegration_CITE_HIVE.Rdata') 

# Write out the UMAP coordinates
write.table(CITE_hive.combined[["umap"]]@cell.embeddings, "UMAP_Coords.txt", sep="\t", col.names=NA, row.names=T, quote=F)
