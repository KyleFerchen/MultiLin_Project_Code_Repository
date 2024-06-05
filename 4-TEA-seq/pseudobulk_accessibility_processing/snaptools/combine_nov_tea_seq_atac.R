# Use R/3.5.0
setwd("/data/salomonis2/LabFiles/Kyle/Analysis/2022_01_11_mouse_tea_seq_atac/")

# Load Required Packages
library(SnapATAC)
library(harmony)


# Paths to data
path_qc_plot <- "output/mouse_tea_seq_nov_combined_EIG_DIMS_QC_PLOT.pdf"
path_tsne_color_by_cluster_plot <- "output/mouse_tea_seq_nov_combined_tsne_by_cluster.pdf"
path_umap_color_by_cluster_plot <- "output/mouse_tea_seq_nov_combined_umap_by_cluster.pdf"
path_cell_anno_output <- "output/mouse_tea_seq_nov_combined_CELL_ANNOTATION.txt"
path_snap_rds_output <- "output/mouse_tea_seq_nov_combined_OUTPUT.RDS"


# Load data
print("Loading data...")
path_to_snap <- "input/snap_atac_input/"

paths_data <- c(paste0(path_to_snap, "AS_TEAr_127_1_atac.snap"),
                paste0(path_to_snap, "AS_TEAr_127_2_atac.snap"),
                paste0(path_to_snap, "AS_TEAr_H1_atac.snap"),
                paste0(path_to_snap, "AS_TEAr_H2_atac.snap"),
                paste0(path_to_snap, "AS_TEAr_kit.snap"),
                paste0(path_to_snap, "AS_TEAr_ML1_atac.snap"),
                paste0(path_to_snap, "AS_TEAr_ML2_atac.snap"))

names_data <- c("AS_TEAr_127_1",
                "AS_TEAr_127_2",
                "AS_TEAr_H1",
                "AS_TEAr_H2",
                "AS_TEAr_kit",
                "AS_TEAr_ML1",
                "AS_TEAr_ML2")


x.sp.ls = lapply(seq(paths_data), function(i){
  x.sp = createSnap(file=paths_data[i], sample=names_data[i]);
  return(x.sp)
})

names(x.sp.ls) <- names_data

barcode.file.list <- c("input/snap_atac_input/AS_TEAr_127_1_atac_barcodes.tsv",
                       "input/snap_atac_input/AS_TEAr_127_2_atac_barcodes.tsv",
                       "input/snap_atac_input/AS_TEAr_H1_atac_barcodes.tsv",
                       "input/snap_atac_input/AS_TEAr_H2_atac_barcodes.tsv",
                       "input/snap_atac_input/AS_TEAr_kit_barcodes.tsv",
                       "input/snap_atac_input/AS_TEAr_ML1_atac_barcodes.tsv",
                       "input/snap_atac_input/AS_TEAr_ML2_atac_barcodes.tsv")

barcode.list = lapply(barcode.file.list, function(file){
  read.table(file)[,1];
})

x.sp.list = lapply(seq(x.sp.ls), function(i){
  x.sp = x.sp.ls[[i]];
  x.sp  = x.sp[x.sp@barcode %in% barcode.list[[i]],];
})

# Add cell-by-bin matrix
print("Adding cell by bin matrices...")
x.sp.list = lapply(seq(x.sp.list), function(i){
  x.sp = addBmatToSnap(x.sp.list[[i]], bin.size=5000);
  x.sp
})


# Combine snap objects
print("Combining snap objects...")
bin.shared = Reduce(intersect, lapply(x.sp.list, function(x.sp) x.sp@feature$name))

x.sp.list <- lapply(x.sp.list, function(x.sp){
  idy = match(bin.shared, x.sp@feature$name);
  x.sp[,idy, mat="bmat"];
})

x.sp = Reduce(snapRbind, x.sp.list)
rm(x.sp.list)
gc()
table(x.sp@sample)

# Binarize matrix
print("Binarizing...")
x.sp = makeBinary(x.sp, mat="bmat")


# Filter bins to remove blacklisted regions
print("Cleaning peaks...")
library(GenomicRanges)
black_list = read.table("/data/salomonis2/LabFiles/Kyle/Reference/blacklisted_genomic_loci/mm10/mm10.blacklist.bed.gz")
black_list.gr = GRanges(
  black_list[,1], 
  IRanges(black_list[,2], black_list[,3])
)
idy = queryHits(findOverlaps(x.sp@feature, black_list.gr))
if(length(idy) > 0){x.sp = x.sp[,-idy, mat="bmat"]}
x.sp


# Remove unwanted chromosomes
chr.exclude = seqlevels(x.sp@feature)[grep("random|chrM", seqlevels(x.sp@feature))]
idy = grep(paste(chr.exclude, collapse="|"), x.sp@feature)
if(length(idy) > 0){x.sp = x.sp[,-idy, mat="bmat"]}


# Remove top 5% of bins that overlap with invariant features
bin.cov = log10(Matrix::colSums(x.sp@bmat)+1)
bin.cutoff = quantile(bin.cov[bin.cov > 0], 0.95)
idy = which(bin.cov <= bin.cutoff & bin.cov > 0)
x.sp = x.sp[, idy, mat="bmat"]
x.sp



# Dimensionality reduction using landmark diffusion map
print("Performing dimensionality reduction...")
row.covs = log10(Matrix::rowSums(x.sp@bmat)+1)
row.covs.dens = density(
  x = row.covs, 
  bw = 'nrd', adjust = 1
)
sampling_prob = 1 / (approx(x = row.covs.dens$x, y = row.covs.dens$y, xout = row.covs)$y + .Machine$double.eps) 
set.seed(1)
idx.landmark.ds = sort(sample(x = seq(nrow(x.sp)), size = 10000, prob = sampling_prob))
x.landmark.sp = x.sp[idx.landmark.ds,]
x.query.sp = x.sp[-idx.landmark.ds,]
x.landmark.sp = runDiffusionMaps(
  obj= x.landmark.sp,
  input.mat="bmat", 
  num.eigs=50
)
x.query.sp = runDiffusionMapsExtension(
  obj1=x.landmark.sp, 
  obj2=x.query.sp,
  input.mat="bmat"
)
x.landmark.sp@metaData$landmark = 1
x.query.sp@metaData$landmark = 0
x.sp = snapRbind(x.landmark.sp, x.query.sp)
## combine landmarks and query cells
x.sp = x.sp[order(x.sp@sample),] # IMPORTANT

# QC Plot Reduced Components
plotDimReductPW(
    obj=x.sp, 
    eigs.dims=1:50,
    point.size=0.3,
    point.color="grey",
    point.shape=19,
    point.alpha=0.6,
    down.sample=5000,
    pdf.file.name=path_qc_plot, 
    pdf.height=7, 
    pdf.width=7
  );

rm(x.landmark.sp, x.query.sp) # free memory



##########################################################################################################################
################################################# Without Batch Correction ###############################################
##########################################################################################################################
print("Visualizing without batch correction...")
x.sp = runKNN(
  obj= x.sp,
  eigs.dim=1:15,
  k=15
)

x.sp = runCluster(
  obj=x.sp,
  tmp.folder=tempdir(),
  louvain.lib="R-igraph",
  path.to.snaptools=NULL,
  seed.use=10
)

x.sp@metaData$cluster = x.sp@cluster
x.sp@metaData$sample = x.sp@sample


x.sp = runViz(
  obj=x.sp, 
  tmp.folder=tempdir(),
  dims=2,
  eigs.dims=1:15, 
  method="Rtsne",
  seed.use=10
)

plotViz(
  obj=x.sp,
  method="tsne", 
  main="Cluster",
  point.color=x.sp@cluster, 
  point.size=0.1, 
  text.add=TRUE,
  text.size=1,
  text.color="black",
  text.halo.add=TRUE,
  text.halo.color="white",
  text.halo.width=0.2,
  down.sample=25000,
  legend.add=FALSE,
  pdf.file.name=path_tsne_color_by_cluster_plot, 
  pdf.height=7, 
  pdf.width=7
)


# Also plot with UMAP
x.sp = runViz(
  obj=x.sp, 
  tmp.folder=tempdir(),
  dims=2,
  eigs.dims=1:15, 
  method="umap",
  seed.use=10
)

# Plot umap by cluster
plotViz(
  obj=x.sp,
  method="umap", 
  main="Cluster",
  point.color=x.sp@cluster, 
  point.size=0.1, 
  text.add=TRUE,
  text.size=1,
  text.color="black",
  text.halo.add=TRUE,
  text.halo.color="white",
  text.halo.width=0.2,
  down.sample=25000,
  legend.add=FALSE,
  pdf.file.name=path_umap_color_by_cluster_plot, 
  pdf.height=7, 
  pdf.width=7
)

print("Saving data without batch correction...")
cell_anno <- cbind(paste0(x.sp@metaData$sample,
                                                "_",
                                                x.sp@metaData$barcode), 
                                         x.sp@metaData, 
                                         x.sp@tsne, 
                                         x.sp@umap)
colnames(cell_anno)[1] <- "cell_id"
write.table(cell_anno, file=path_cell_anno_output, sep="\t", quote=F,
            row.names=F, col.names=T)

saveRDS(x.sp, file=path_snap_rds_output)