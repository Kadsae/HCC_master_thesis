### script for working on enrichment analysis for the master thesis ###

# load needed libraries
library(clusterProfiler)
library(msigdbr)
library(tidyverse)
library(limma)
library(DOSE)
library(enrichplot)
library(EnhancedVolcano)

# assign variables to needed directories
datadir <- "../data/"
resultsdir <- "../results/"
plotsdir <- "../plots/"

# read in created data from 01 and 02
res.eset <- readRDS(file.path(datadir, "intermediate", "tumor_list_res_eset.RDS"))
res.gsva <- readRDS(file.path(datadir, "intermediate", "tumor_list_res_gsva.RDS")) 

# saving res of eset in a new variable for easier readability
res <- res.eset %>% purrr::map(data.frame)

# creating list of differentially expressed genes for every contrast
degs <- res %>% purrr::map(function(x) {
  x %>%
    dplyr::filter(adj.P.Val < 0.05) %>%
    dplyr::select(SYMBOL) %>%
    deframe()
})

# downloading whole database for species rat and saving it to a new variable
genesets <- msigdbr(species = "rat")

# TERM2NAME for enrichment analysis, taken from the molsigdb
TERM2NAME <- genesets %>%
  dplyr::select(gs_id, gs_name) %>%
  distinct()

################################################################################

# enrichment analysis with KEGG database, all variables set to default
kegg_enrichment <- degs %>%
  purrr::map(function(x) {
    x %>%
      enricher(pvalueCutoff = 0.05,
               pAdjustMethod = "BH",
               minGSSize = 15,
               maxGSSize = 500,
               TERM2GENE = genesets %>% 
                 dplyr::filter(gs_cat == "C2", gs_subcat == "CP:KEGG") %>%
                 dplyr::select(gs_id, gene_symbol),
               TERM2NAME = TERM2NAME)
  })

# copy and paste for GO/wikipathways/reactome
# enrichment analysis with GO database, all variables set to default
go_enrichment <- degs %>%
  purrr::map(function(x) {
    x %>%
      enricher(pvalueCutoff = 0.05,
               pAdjustMethod = "BH",
               minGSSize = 15,
               maxGSSize = 500,
               TERM2GENE = genesets %>% 
                 dplyr::filter(gs_cat == "C5", gs_subcat == "GO:BP") %>%
                 dplyr::select(gs_id, gene_symbol),
               TERM2NAME = TERM2NAME)
  })

# enrichment analysis with wikipathways database, all variables set to default
wp_enrichment <- degs %>%
  purrr::map(function(x) {
    x %>%
      enricher(pvalueCutoff = 0.05,
               pAdjustMethod = "BH",
               minGSSize = 15,
               maxGSSize = 500,
               TERM2GENE = genesets %>% 
                 dplyr::filter(gs_cat == "C2", gs_subcat == "CP:WIKIPATHWAYS") %>%
                 dplyr::select(gs_id, gene_symbol),
               TERM2NAME = TERM2NAME)
  })

# enrichment analysis with reactome database, all variables set to default
reactome_enrichment <- degs %>%
  purrr::map(function(x) {
    x %>%
      enricher(pvalueCutoff = 0.05,
               pAdjustMethod = "BH",
               minGSSize = 15,
               maxGSSize = 500,
               TERM2GENE = genesets %>% 
                 dplyr::filter(gs_cat == "C2", gs_subcat == "CP:REACTOME") %>%
                 dplyr::select(gs_id, gene_symbol),
               TERM2NAME = TERM2NAME)
  })

################################################################################

### Volcanoplot for dgea results

# kevals to differentiate between up- and downregulated genes in terms of logFC and adj. P-value
keyvals <- ifelse(res$`carcinoma - adjacent_tissue`$logFC < -2 & res$`carcinoma - adjacent_tissue`$adj.P.Val < 0.05, 'blue',
           ifelse(res$`carcinoma - adjacent_tissue`$logFC > 2 & res$`carcinoma - adjacent_tissue`$adj.P.Val < 0.05, 'red',
           'black'))
keyvals[is.na(keyvals)] <- 'black'
names(keyvals)[keyvals == 'red'] <- 'upregulated genes'
names(keyvals)[keyvals == 'black'] <- 'NS'
names(keyvals)[keyvals == 'blue'] <- 'downregulated genes'

# drawing of volcano plot with enhanced volcano plot package
EnhancedVolcano(res$`carcinoma - adjacent_tissue`,
                lab = res$`carcinoma - adjacent_tissue`$SYMBOL,
                x = "logFC",
                y = "adj.P.Val",
                xlab = bquote(~Log[2]~ 'fold change'),
                ylab = bquote(~-Log[10]~adjusted~italic(P)),
                xlim = c(-6,6),
                ylim = c(0,12),
                selectLab = rownames(res)[which(names(keyvals) %in% c('upregulated genes', 'downregulated genes'))],
                pCutoff = 0.05,
                FCcutoff = 2,
                #title = "Carcinoma expression set",
                #legendLabels = c('NS','Log2 FC','Adjusted p-value', 'Adj. p-value & Log2 FC'),
                #legendLabSize = 10,
                colCustom = keyvals,
                border = "full",
                borderWidth = 1,
                borderColour = 'black')

################################################################################

# Volcanoplot for gsva results

# writing gsva results in a new variable as a dataframe
res <- res.gsva %>% purrr::map(data.frame)

# removal of underscores in the gs_name column
res$`carcinoma - adjacent_tissue`$gs_name <- gsub("_", " ", res$`carcinoma - adjacent_tissue`$gs_name)
res$`adenoma - adjacent_tissue`$gs_name <- gsub("_", " ", res$`adenoma - adjacent_tissue`$gs_name)

# kevals to differentiate between up- and downregulated genes in terms of logFC and adj. P-value
keyvals <- ifelse(res$`carcinoma - adjacent_tissue`$logFC < -0.5 & res$`carcinoma - adjacent_tissue`$adj.P.Val < 0.05, 'blue',
                  ifelse(res$`carcinoma - adjacent_tissue`$logFC > 0.5 & res$`carcinoma - adjacent_tissue`$adj.P.Val < 0.05, 'red',
                         'black'))
keyvals[is.na(keyvals)] <- 'black'
names(keyvals)[keyvals == 'red'] <- 'upregulated pathways'
names(keyvals)[keyvals == 'black'] <- 'NS'
names(keyvals)[keyvals == 'blue'] <- 'downregulated pathways'

# writing top 5 and bottom 5 results in terms of logFC of every stage in a new variable
carcinoma <- rbind(head(res$`carcinoma - adjacent_tissue`[order(res$`carcinoma - adjacent_tissue`$logFC),], n = 5),
                   tail(res$`carcinoma - adjacent_tissue`[order(res$`carcinoma - adjacent_tissue`$logFC),], n = 5))

adenoma <- rbind(head(res$`adenoma - adjacent_tissue`[order(res$`adenoma - adjacent_tissue`$logFC),], n = 5),
                 tail(res$`adenoma - adjacent_tissue`[order(res$`adenoma - adjacent_tissue`$logFC),], n = 5))

# drawing of volcano plot with enhanced volcano plot package
EnhancedVolcano(res$`carcinoma - adjacent_tissue`,
                lab = res$`carcinoma - adjacent_tissue`$gs_name,
                x = "logFC",
                y = "adj.P.Val",
                selectLab = carcinoma$gs_name,
                xlab = bquote(~Log[2]~ 'fold change'),
                ylab = bquote(~-Log[10]~adjusted~italic(P)),
                #title = "Adenoma GSVA set",
                xlim = c(-2,2),
                ylim = c(0,10),
                pCutoff = 0.05,
                FCcutoff = 0.5,
                labSize = 3.0,
                labFace = "bold",
                colCustom = keyvals,
                #legendLabels = c('NS','Log2 FC','Adjusted p-value', 'Adj. p-value & Log2 FC'),
                #legendLabSize = 10,
                boxedLabels = TRUE,
                drawConnectors = TRUE,
                widthConnectors = 1.0,
                lengthConnectors = 5.0,
                arrowheads = FALSE,
                border = "full",
                borderWidth = 1,
                borderColour = 'black')

################################################################################

### dotplots via clusterprofiler for term enrichment
dotplot(kegg_enrichment$`adenoma - adjacent_tissue`, x="count", showCategory=20)

################################################################################

### venn diagram for visualization of deregulated genes across all stages

data <- rio::import_list(resultsdir, "regulation_stages.xlsx")

data_venn <- data %>%
  purrr::map(function(list){
    result <- as.list(list) %>%
      purrr::map(function(x){
        x[!is.na(x)]
      })
  })

venn.diagram(x = data_venn$down,
             category.names = c("FOCI" , 
                                "ADENOMA" , 
                                "CARCINOMA"),
             filename = 'venn_diagram_down.png',
             output=TRUE,
             imagetype="png" ,
             height = 900 , 
             width = 1000 , 
             resolution = 300,
             compression = "lzw",
             lwd = 1,
             col=c("darkgreen", 
                   'royalblue2', 
                   'firebrick1'),
             fill = c(alpha("darkgreen",0.8), 
                      alpha('royalblue2',0.8), 
                      alpha('firebrick1',0.8)),
             cex = 0.75,
             fontface = 5,
             fontfamily = "sans",
             cat.cex = 0.75,
             cat.default.pos = "outer",
             cat.pos = c(-20, 20, 180),
             cat.dist = c(0.055, 0.055, 0.03),
             cat.fontfamily = "sans",
             cat.col = c("darkgreen", 
                         'royalblue2', 
                         'firebrick1'),
             rotation = 1
)

################################################################################

