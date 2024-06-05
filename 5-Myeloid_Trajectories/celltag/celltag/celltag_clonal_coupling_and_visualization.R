library(rlist)
library(ggplot2)

setwd("/Users/tha8tf/Annie_CellTag_ClonalCouplingScores/Saturation_60_clones/")

allgroups = read.table("QueryGroups.cellHarmony_ScaP1_P2_Neg1_Neg2.txt", sep = "\t", stringsAsFactors = F, header = F,row.names = 1)

scap1 = read.table("ScaP1_RNA_clones.csv", sep = ",", stringsAsFactors = F, header = T)
scap2 = read.table("ScaP2_RNA_clones.csv", sep = ",", stringsAsFactors = F, header = T)
scap1$cell.bc = gsub("ScaP1_RNA-","",scap1$cell.bc)
scap1$cell.bc = paste0(scap1$cell.bc,".ScaP1")
scap1$clone.id = paste0("clone.id_",scap1$clone.id)
scap1$groups = allgroups[scap1$cell.bc,2]
scap2$cell.bc = gsub("ScaP2_RNA-","",scap2$cell.bc)
scap2$cell.bc = paste0(scap2$cell.bc,".ScaP2")
scap2$clone.id = paste0("clone.id_",scap2$clone.id)
scap2$groups = allgroups[scap2$cell.bc,2]

scaneg1 = read.table("ScaNeg1_RNA_clones.csv", sep = ",", stringsAsFactors = F, header = T)
scaneg2 = read.table("ScaNeg2_RNA_clones.csv", sep = ",", stringsAsFactors = F, header = T)
scaneg1$cell.bc = gsub("ScaNeg1_RNA-","",scaneg1$cell.bc)
scaneg1$cell.bc = paste0(scaneg1$cell.bc,".ScaNeg1")
scaneg1$clone.id = paste0("clone.id_",scaneg1$clone.id)
scaneg1$groups = allgroups[scaneg1$cell.bc,2]
scaneg2$cell.bc = gsub("ScaNeg2_RNA-","",scaneg2$cell.bc)
scaneg2$cell.bc = paste0(scaneg2$cell.bc,".ScaNeg2")
scaneg2$clone.id = paste0("clone.id_",scaneg2$clone.id)
scaneg2$groups = allgroups[scaneg2$cell.bc,2]

clones = scap1
groups = scap1$groups

observed_matrix = as.data.frame(matrix(NA,nrow = length(sort(unique(groups))), ncol =length(sort(unique(groups)))))
rownames(observed_matrix) = sort(unique(groups))
colnames(observed_matrix) = sort(unique(groups))

for (i in sort(unique(groups))){
  for (j in sort(unique(groups))){
    sharedclones = length(intersect(clones$clone.id[clones$groups==i], clones$clone.id[clones$groups==j]))
    observed_matrix[i,j] = sharedclones
    #print(paste0("sharedclones ", i, j, ": ",sharedclones))
  }
} 


row_total = rowSums(observed_matrix)
col_total = colSums(observed_matrix)
total = sum(col_total)
expected_matrix = as.data.frame(matrix(NA,nrow = length(sort(unique(groups))), ncol =length(sort(unique(groups)))))
rownames(expected_matrix) = sort(unique(groups))
colnames(expected_matrix) = sort(unique(groups))

for (i in sort(unique(groups))){
  for (j in sort(unique(groups))){
    e = (row_total[i]*col_total[j])/total
    expected_matrix[i,j] = e
    #print(paste0("e val ", i, j, ": ",e))
  }
} 


eij_oij = observed_matrix/expected_matrix

eij_oij_melt =  reshape2::melt(as.matrix(eij_oij))
self_loop_edges = which(eij_oij_melt$Var1 == eij_oij_melt$Var2)
max(eij_oij_melt$value[-self_loop_edges])

eij_oij_melt$value[eij_oij_melt$value >= 30] = 30
eij_oij_melt$value[eij_oij_melt$value <= 1/30] = 1/30
eij_oij_melt$value = log2(eij_oij_melt$value)

pdf("SCAP1_Raw_Clonal_Relationships_Heatmap_Clones.pdf",height = 15,width = 15)
p = ggplot(data = eij_oij_melt, aes(x=Var1, y=Var2, fill=value)) +
  geom_tile() + 
  scale_fill_gradientn(colours=c("blue","white","red"), limits=c(-5,5)) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),text = element_text(size=20))
show(p)
dev.off()

scap2 = na.omit(scap2)
clones = scap2
groups = scap2$groups

observed_matrix = as.data.frame(matrix(NA,nrow = length(sort(unique(groups))), ncol =length(sort(unique(groups)))))
rownames(observed_matrix) = sort(unique(groups))
colnames(observed_matrix) = sort(unique(groups))

for (i in sort(unique(groups))){
  for (j in sort(unique(groups))){
    sharedclones = length(intersect(clones$clone.id[clones$groups==i], clones$clone.id[clones$groups==j]))
    observed_matrix[i,j] = sharedclones
    #print(paste0("sharedclones ", i, j, ": ",sharedclones))
  }
} 


row_total = rowSums(observed_matrix)
col_total = colSums(observed_matrix)
total = sum(col_total)
expected_matrix = as.data.frame(matrix(NA,nrow = length(sort(unique(groups))), ncol =length(sort(unique(groups)))))
rownames(expected_matrix) = sort(unique(groups))
colnames(expected_matrix) = sort(unique(groups))

for (i in sort(unique(groups))){
  for (j in sort(unique(groups))){
    e = (row_total[i]*col_total[j])/total
    expected_matrix[i,j] = e
    #print(paste0("e val ", i, j, ": ",e))
  }
} 


eij_oij = observed_matrix/expected_matrix

eij_oij_melt =  reshape2::melt(as.matrix(eij_oij))
self_loop_edges = which(eij_oij_melt$Var1 == eij_oij_melt$Var2)
max(eij_oij_melt$value[-self_loop_edges])

eij_oij_melt$value[eij_oij_melt$value >= 30] = 30
eij_oij_melt$value[eij_oij_melt$value <= 1/30] = 1/30
eij_oij_melt$value = log2(eij_oij_melt$value)

pdf("SCAP2_Raw_Clonal_Relationships_Heatmap_Clones.pdf",height = 15,width = 15)
p = ggplot(data = eij_oij_melt, aes(x=Var1, y=Var2, fill=value)) +
  geom_tile() + 
  scale_fill_gradientn(colours=c("blue","white","red"), limits=c(-5,5)) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),text = element_text(size=20))
show(p)
dev.off()

scaneg1 = na.omit(scaneg1)
clones = scaneg1
groups = scaneg1$groups

observed_matrix = as.data.frame(matrix(NA,nrow = length(sort(unique(groups))), ncol =length(sort(unique(groups)))))
rownames(observed_matrix) = sort(unique(groups))
colnames(observed_matrix) = sort(unique(groups))

for (i in sort(unique(groups))){
  for (j in sort(unique(groups))){
    sharedclones = length(intersect(clones$clone.id[clones$groups==i], clones$clone.id[clones$groups==j]))
    observed_matrix[i,j] = sharedclones
    #print(paste0("sharedclones ", i, j, ": ",sharedclones))
  }
} 


row_total = rowSums(observed_matrix)
col_total = colSums(observed_matrix)
total = sum(col_total)
expected_matrix = as.data.frame(matrix(NA,nrow = length(sort(unique(groups))), ncol =length(sort(unique(groups)))))
rownames(expected_matrix) = sort(unique(groups))
colnames(expected_matrix) = sort(unique(groups))

for (i in sort(unique(groups))){
  for (j in sort(unique(groups))){
    e = (row_total[i]*col_total[j])/total
    expected_matrix[i,j] = e
    #print(paste0("e val ", i, j, ": ",e))
  }
} 


eij_oij = observed_matrix/expected_matrix

eij_oij_melt =  reshape2::melt(as.matrix(eij_oij))
self_loop_edges = which(eij_oij_melt$Var1 == eij_oij_melt$Var2)
max(eij_oij_melt$value[-self_loop_edges])

eij_oij_melt$value[eij_oij_melt$value >= 30] = 30
eij_oij_melt$value[eij_oij_melt$value <= 1/30] = 1/30
eij_oij_melt$value = log2(eij_oij_melt$value)

pdf("SCANEG1_Raw_Clonal_Relationships_Heatmap_Clones.pdf",height = 15,width = 15)
p = ggplot(data = eij_oij_melt, aes(x=Var1, y=Var2, fill=value)) +
  geom_tile() + 
  scale_fill_gradientn(colours=c("blue","white","red"), limits=c(-5,5)) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),text = element_text(size=20))
show(p)
dev.off()


scaneg2 = na.omit(scaneg2)
clones = scaneg2
groups = scaneg2$groups

observed_matrix = as.data.frame(matrix(NA,nrow = length(sort(unique(groups))), ncol =length(sort(unique(groups)))))
rownames(observed_matrix) = sort(unique(groups))
colnames(observed_matrix) = sort(unique(groups))

for (i in sort(unique(groups))){
  for (j in sort(unique(groups))){
    sharedclones = length(intersect(clones$clone.id[clones$groups==i], clones$clone.id[clones$groups==j]))
    observed_matrix[i,j] = sharedclones
    #print(paste0("sharedclones ", i, j, ": ",sharedclones))
  }
} 


row_total = rowSums(observed_matrix)
col_total = colSums(observed_matrix)
total = sum(col_total)
expected_matrix = as.data.frame(matrix(NA,nrow = length(sort(unique(groups))), ncol =length(sort(unique(groups)))))
rownames(expected_matrix) = sort(unique(groups))
colnames(expected_matrix) = sort(unique(groups))

for (i in sort(unique(groups))){
  for (j in sort(unique(groups))){
    e = (row_total[i]*col_total[j])/total
    expected_matrix[i,j] = e
    #print(paste0("e val ", i, j, ": ",e))
  }
} 


eij_oij = observed_matrix/expected_matrix

eij_oij_melt =  reshape2::melt(as.matrix(eij_oij))
self_loop_edges = which(eij_oij_melt$Var1 == eij_oij_melt$Var2)
max(eij_oij_melt$value[-self_loop_edges])

eij_oij_melt$value[eij_oij_melt$value >= 30] = 30
eij_oij_melt$value[eij_oij_melt$value <= 1/30] = 1/30
eij_oij_melt$value = log2(eij_oij_melt$value)

pdf("SCANEG2_Raw_Clonal_Relationships_Heatmap_Clones.pdf",height = 15,width = 15)
p = ggplot(data = eij_oij_melt, aes(x=Var1, y=Var2, fill=value)) +
  geom_tile() + 
  scale_fill_gradientn(colours=c("blue","white","red"), limits=c(-5,5)) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),text = element_text(size=20))
show(p)
dev.off()



