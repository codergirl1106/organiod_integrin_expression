print("wow")
library(Seurat)
library(dplyr)
library(ggplot2)
print("huh")
hi <- readRDS("./rds_file.rds")

hi <- hi %>% 
  NormalizeData() %>% 
  FindVariableFeatures() %>% 
  ScaleData() %>% 
  RunPCA() %>% 
  RunUMAP(dims = 1:30)

umap_coords <- hi@reductions$umap@cell.embeddings
umap_coords <- merge(umap_coords, hi@meta.data, by="row.names")
write.csv(umap_coords, file="./umap_data.csv", row.names = FALSE)

print(head(umap_coords))

tbll <- data.frame()
genes <- c("ENSG00000213949", "ENSG00000164171", "ENSG00000005884", "ENSG00000115232", "ENSG00000161638", "ENSG00000091409", "ENSG00000135424", "ENSG00000077943", "ENSG00000144668", "ENSG00000143127", "ENSG00000137809", "ENSG00000156886", "ENSG00000083457", "ENSG00000005844", "ENSG00000169896", "ENSG00000138448", "ENSG00000005961", "ENSG00000140678", "ENSG00000150093", "ENSG00000160255", "ENSG00000259207", "ENSG00000132470", "ENSG00000082781", "ENSG00000115221", "ENSG00000139626", "ENSG00000105855", "ENSG00000105329", "ENSG00000092969", "ENSG00000119699", "ENSG00000049323", "ENSG00000119681", "ENSG00000168056", "ENSG00000090006", "ENSG00000137507", "ENSG00000174004")
for (celltypes in unique(hi@meta.data$cell_type)) {
  subsection <- hi@assays$RNA@counts[genes,rownames(hi@meta.data[hi@meta.data$cell_type == celltypes,])]
  print(rowSums(subsection)/ncol(subsection))
  if (ncol(tbll) == 0) {
    tbll <- data.frame(cc = rowSums(subsection)/ncol(subsection))
    colnames(tbll) <- celltypes
  } else {
    tbll[[celltypes]] <- rowSums(subsection)/ncol(subsection)
  }
}

print("cool")

rownames(tbll) <- c("ITGA1", "ITGA2", "ITGA3", "ITGA4", "ITGA5", "ITGA6", "ITGA7", "ITGA8", "ITGA9", "ITGA10", "ITGA11", "ITGAD", "ITGAE", "ITGAL", "IGTAM", "ITGAV", "ITGA2B", "ITGAX", "ITGB1", "ITGB2", "ITGB3", "ITGB4", "ITGB5", "ITGB6", "ITGB7", "ITGB8", "TGFB1", "TGFB2", "TGFB3", "LTBP1", "LTBP2", "LTBP3", "LTBP4", "LRRC32", "NRROS")

write.csv(tbll, file="./integrin_expression.csv")
