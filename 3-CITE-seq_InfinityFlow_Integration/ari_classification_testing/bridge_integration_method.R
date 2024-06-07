#Bridge integration of pyinfinity data with citeseq and single cell rnaseq
#Reference and Bridge can have different number of cells
#Query should have same features as the bridge
work_dir=("/data/salomonis2/LabFiles/Priyanka/brdige_integration/")
setwd(work_dir)
#Run bridge integration
Sys.setenv(http_proxy="http://raw6jg:chmc95780212@bmiproxyp.chmcres.cchmc.org:80")
Sys.setenv(https_proxy="http://raw6jg:chmc95780212@bmiproxyp.chmcres.cchmc.org:80")
#install.packages("arrow")
library("arrow")
library("remotes")
#install.packages("remotes")
remotes::install_github("satijalab/seurat", "feat/dictionary", quiet = FALSE,force=TRUE)
library(Seurat)
library(SeuratDisk)
library(EnsDb.Hsapiens.v86)
library(dplyr)
library(ggplot2)
library(dictionaRy)
#single cell data
#HSCP_scRNA<-Read10X(data.dir = "/data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/biolegend-genomics-cchmc/fastq/HSCP/HSCP/outs/count/SoupX-revised/soupX-contamination-fraction-0.15/")
#MultiLin<-Read10X(data.dir = "/data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/biolegend-genomics-cchmc/fastq/Multi_Lin/Multi_Lin/outs/count/SoupX-revised/soupX-contamination-fraction-0.15/")
#Kit_CD117<-Read10X(data.dir = "/data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/biolegend-genomics-cchmc/fastq/Kit_CD117/Kit_CD117_02_24_22/outs/count/SoupX-revised/soupX-contamination-fraction-0.15/")
#CD127<-Read10X(data.dir = "/data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/biolegend-genomics-cchmc/fastq/CD127/CD127/outs/count/SoupX-revised/soupX-contamination-fraction-0.15/")
#create seurat object and merge to create source
#HSCP_seurat<-CreateSeuratObject(counts=HSCP_scRNA,project = "HSCP")
#MultiLin_seurat<-CreateSeuratObject(counts=MultiLin,project="MultiLin")
#Kit_CD117_seurat<-CreateSeuratObject(counts=Kit_CD117,project="Kit_CD117")
#CD127_seurat<-CreateSeuratObject(counts=CD127,project="CD127")
#scRNA_final<-merge(HSCP_seurat,y=c(MultiLin_seurat,Kit_CD117_seurat,CD127_seurat),project="final_scRNA")
#Upload citeseq data as bridge reference
AS3_citekit<-Read10X_h5("/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_3CITE_Kit/AS_3CITE_Kit/outs/filtered_feature_bc_matrix.h5")
AS3_citekitx2<-Read10X_h5("/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_3CITE_Kitx2/AS_3CITE_Kitx2/outs/AS_3CITE_Kitx2.h5")
CD127_cite<-Read10X_h5("/data/salomonis2/Grimes/RNA/scRNA-Seq//10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_CITE_CD127/AS_CITE_CD127/outs/filtered_feature_bc_matrix.h5")
HSC_cite<-Read10X_h5("/data/salomonis2/Grimes/RNA/scRNA-Seq//10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_CITE_HSC/AS_CITE_HSC/outs/filtered_feature_bc_matrix.h5")
MultiLin1_cite<-Read10X_h5("/data/salomonis2/Grimes/RNA/scRNA-Seq//10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_CITE_Multilin1/AS_CITE_Multilin1/outs/filtered_feature_bc_matrix.h5")
MuliLin2_cite<-Read10X_h5("/data/salomonis2/Grimes/RNA/scRNA-Seq//10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_CITE_Multilin2/AS_CITE_Multilin2/outs/filtered_feature_bc_matrix.h5")
AS_cite_kit<-Read10X_h5("/data/salomonis2/Grimes/RNA/scRNA-Seq//10x-Genomics/LGCHMC32_IGM/cellranger-ADT/AS_CITE_Kit/AS_CITE_Kit/outs/filtered_feature_bc_matrix.h5")
# Create Seurat object
AS3_citekit_seurat<-CreateSeuratObject(counts=AS3_citekit$`Gene Expression`,project="AS_3CITE_Kit")
AS_cite_kit_seurat_RNA<-CreateSeuratObject(counts=AS_cite_kit$`Gene Expression`,project="AS_CITE_Kit")
AS3_citekitx2_seurat_RNA<-CreateSeuratObject(counts=AS3_citekitx2$`Gene Expression`,project="AS_3CITE_Kitx2")
CD127_cite_RNA<-CreateSeuratObject(counts=CD127_cite$`Gene Expression`,project="AS_CITE_CD127")
MultiLin1_RNA<-CreateSeuratObject(counts = MultiLin1_cite$`Gene Expression`,project="AS_CITE_Multilin1")
MultiLin2_RNA<-CreateSeuratObject(counts=MuliLin2_cite$`Gene Expression`,project="AS_CITE_Multilin2")
HSC_cite_RNA<-CreateSeuratObject(counts=HSC_cite$`Gene Expression`,project="AS_CITE_HSC")
Citeseq.list<-list(AS3_citekit_seurat,AS_cite_kit_seurat_RNA,AS3_citekitx2_seurat_RNA,CD127_cite_RNA,MultiLin1_RNA,MultiLin2_RNA,HSC_cite_RNA)
Citeseq.list<-lapply(X=Citeseq.list,FUN=function(x){x<-NormalizeData(x)
  x<-FindVariableFeatures(x,selection.method="vst",nfeatures=2000)})
features_citeseq.rna<-SelectIntegrationFeatures(Citeseq.list)
Citeseq.list<-lapply(X=Citeseq.list,FUN=function(x){x<-ScaleData(x,features=features_citeseq.rna)
 x<-RunPCA(x,features=features_citeseq.rna)})
Citeseq.anchors<-FindIntegrationAnchors(Citeseq.list,reduction="rpca",dims=1:30)
Citeseq.integrated<-IntegrateData(anchors=Citeseq.anchors,dims=1:30)
Citeseq.integrated<-ScaleData(Citeseq.integrated)
Citeseq.integrated<-RunPCA(Citeseq.integrated)
Citeseq.integrated<-RunUMAP(Citeseq.integrated,dims=1:30)
saveRDS(Citeseq.integrated,file="CiteSeq.integrated.RDS")
#Add citeseq data
AS3_citekit_ADT<-CreateSeuratObject(counts=AS3_citekit$`Antibody Capture`,project="AS_3CITE_Kit")
AS_cite_kit_ADT<-CreateSeuratObject(counts=AS_cite_kit$`Antibody Capture`,project="AS_CITE_Kit")
AS3_citekitx2_ADT<-CreateSeuratObject(counts=AS3_citekitx2$`Antibody Capture`,project="AS_3CITE_Kitx2")
CD127_cite_ADT<-CreateSeuratObject(counts=CD127_cite$`Antibody Capture`,project="AS_CITE_CD127")
MultiLin1_ADT<-CreateSeuratObject(counts=MultiLin1_cite$`Antibody Capture`,project="AS_CITE_Multilin1")
MultiLin2_ADT<-CreateSeuratObject(counts=MuliLin2_cite$`Antibody Capture`,project="AS_CITE_Multilin2")
HSC_cite_ADT<-CreateSeuratObject(counts = HSC_cite$`Antibody Capture`,project="AS_CITE_HSC")
Final_citeseq_ADT.list=list(CD127_cite_ADT,AS_cite_kit_ADT,AS3_citekit_ADT,AS3_citekitx2_ADT,HSC_cite_ADT,MultiLin1_ADT,MultiLin2_ADT)
Final_citeseq_ADT.list<-lapply(X=Final_citeseq_ADT.list,FUN=function(x){x<-NormalizeData(x,normalization.method='CLR',margin=2)
x<-FindVariableFeatures(x,selection.method="vst",nfeatures=2000)})
Final_citeseq_features<-SelectIntegrationFeatures(Final_citeseq_ADT.list)
Final_citeseq_ADT.list<-lapply(X=Final_citeseq_ADT.list,FUN=function(x){x<-ScaleData(x,features=Final_citeseq_features)
 x<-RunPCA(x,features=Final_citeseq_features)})
ADT.anchors<-FindIntegrationAnchors(Final_citeseq_ADT.list,reduction="rpca",dims=1:30)
Citeseq_ADT.integrated<-IntegrateData(anchors=ADT.anchors,dims=1:30)
Citeseq_ADT.integrated<-ScaleData(Citeseq_ADT.integrated)
Citeseq_ADT.integrated<-RunPCA(Citeseq_ADT.integrated)
Citeseq_ADT.integrated<-RunUMAP(Citeseq_ADT.integrated,dims=1:30)
saveRDS(Citeseq_ADT.integrated,file="CiteSeq_ADT.integrated.RDS")
#Integrate CiteSeq integrated and ADT integrated for preparing integrated bridge data
Citeseq.integrated[["ADT"]]<-Citeseq_ADT.integrated[["integrated"]]
Citeseq.integrated[["pca.adt"]]<-Citeseq_ADT.integrated[["pca"]]
Citeseq.integrated[["umap.adt"]]<-Citeseq_ADT.integrated[["umap"]]
#filter the final object for cell annotations
Bridge_object_citeseq_adt_2<-subset(Citeseq.integrated,cells=cell.use)
saveRDS(Bridge_object_citeseq_adt_2,file="Bridge_object_citeseq_adt_2.rds")
# Load the pyinfinity flow data
pyflow<-read.delim(file="pyflow_data-1.csv",header = TRUE,sep = ",")
#ADT_py<-read.delim(file="raw_cite_adt_rename_features_to_map_to_flow.csv",header = TRUE,sep = ",")
pyflow2<-as.matrix(t(pyflow))
colnames(pyflow2)<-pyflow2[1,]
pyflow2<-pyflow2[-1,]
#ADT_flow<-ADT_py[-1]
#rownames(ADT_flow)<-ADT_py$UID
#make an object with ADT counts
pyflow2<-CreateSeuratObject(counts=pyflow2,project="infintypy",)
pyflow2<-RenameAssays(pyflow2,originalexp="ADT")
VariableFeatures(pyflow2)<-colnames(pyflow2)
pyflow2<-NormalizeData(pyflow2,normalization.method = 'CLR',margin=2)
pyflow2<-ScaleData(pyflow2)
pyflow2<-FindVariableFeatures(pyflow2)
pyflow2<-RunPCA(pyflow2,reduction.name = 'apca')

#Match ADT proteins in Citeseq ADT and ADT_flow
DefaultAssay(Bridge_object_citeseq_adt_2)<-"ADT"
ADT_features= intersect(rownames(Bridge_object_citeseq_adt_2[["ADT"]]),rownames(ADT_flow))
VariableFeatures(Bridge_object_citeseq_adt_2)<-ADT_features
#Scale the object according to the variable features
Bridge_object_citeseq_adt_2<-ScaleData(Bridge_object_citeseq_adt_2,features=ADT_features,do.scale = FALSE)
#Bridge Integration
dims.adt=1:50
dims.rna=1:20
DefaultAssay(Bridge_object_citeseq_adt_2)<-"RNA"
kpop.combined_integrated_scrna<-SCTransform(kpop.combined_integrated_scrna)
kpop.combined_integrated_scrna<-RunPCA(kpop.combined_integrated_scrna)
kpop.combined_integrated_scrna<-RunUMAP(kpop.combined_integrated_scrna,dims = 1:50,return.model = TRUE)
saveRDS(kpop.combined_integrated_scrna,file="cite.rds")
obj.rna.ext<-PrepareBridgeReference(reference=kpop.combined_integrated_scrna,bridge=Bridge_object_citeseq_adt_2,bridge.query.assay ="ADT",reference.reduction="pca",normalization.method="SCT",verbose=TRUE)
saveRDS(obj.rna.ext,file="bridge_ref.rds")

#Bridge integration
#Prepare reference 
#scRNA_final<-readRDS(file="scRNA_bridge_integration.rds") 
#scRNA_final<-SCTransform(scRNA_final)%>%RunPCA()%>%RunUMAP(dims=1:50,return.model=TRUE)
#saveRDS(scRNA_final,file="scRNA_final_sctransformed.rds")
#Normalize multiome
#Final_citeseq<-readRDS(file="CiteSeq_MultiLin_bridge_integration.rds")
#DefaultAssay(Final_citeseq)<-"RNA"
#VariableFeatures(Final_citeseq)<-rownames(Final_citeseq)
#Final_citeseq<-SCTransform(Final_citeseq,verbose=TRUE)
#DefaultAssay(Final_citeseq)<-"ADT"
#VariableFeatures(Final_citeseq)<-rownames(Final_citeseq)
#Final_citeseq<-NormalizeData(Final_citeseq,normalization.method='CLR',margin=2, verbose=TRUE)
#Final_citeseq<-ScaleData(Final_citeseq,verbose=TRUE)
#saveRDS(Final_citeseq,file="Final_citeseq_normalized_ADT_1.rds")
Cell_annotations<-read.delim(file="QueryGroups.cellHarmony-titrated_changed.txt",header =FALSE)
cell.use<-Cell_annotations$V1
Final_scrna_filtered<-subset(Final_citeseq_normalized_ADT_1,cells=cell.use)