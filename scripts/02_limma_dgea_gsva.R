### script for working on dgea and gsva for the master thesis ###
### Author: Florian Himmelbauer                               ###

# load needed libraries
library(limma)
library(msigdbr)
library(GSVA)
library(tidyverse)
library(genefilter) # for featurefilter

# assign variables to needed directories
datadir <- "../data/"
resultsdir <- "../results/"
plotsdir <- "../plots/"

# read in created eset from "preprocessing.R"
eset <- readRDS(file.path(datadir, "intermediate", "tumor_ExpressionSet_outlierremoved.RDS"))

### writing design matrix

# change integer to character for model.matrix
eset$INDIVIDUAL <- as.character(eset$INDIVIDUAL)
eset$STORAGE <- as.factor(eset$STORAGE)

# create design matrix
design <- model.matrix( ~ 0 + eset$STAGE + eset$INDIVIDUAL + eset$STORAGE )
colnames(design) <- c("adenoma",
                      "adjacent_tissue", 
                      "carcinoma", 
                      "foci", 
                      "nodule", 
                      "individual11", 
                      "individual14", 
                      "individual18", 
                      "individual21", 
                      "individual23", 
                      "individual7", 
                      "storage")
rownames(design) <- eset$SAMPLEID

# contrast fit function with contrast matrix
# stages - adjacent tissue
contrast.matrix <- makeContrasts(adenoma-adjacent_tissue,
                                 carcinoma-adjacent_tissue,
                                 foci-adjacent_tissue,
                                 nodule-adjacent_tissue,
                                 individual11, 
                                 individual14, 
                                 individual18, 
                                 individual21, 
                                 individual23, 
                                 individual7, 
                                 storage,
                                 levels=design)

# writing all names of coeffients from the contrastmatrix in a new variable
coefs <- colnames(contrast.matrix) %>% 
  set_names(.,.)

################################################################################

### gsva for gene set variation analysis

# downloading whole database for species rat and saving it to a new variable
genesets = msigdbr(species = "rat")

# large list containing gs ids and corresponding entrez gene names
gs <- genesets %>%
  dplyr::select(gs_id, entrez_gene) %>%
  # group by geneset id
  tidyr::nest(gg = -"gs_id") %>%
  # convert into a list of dataframes
  deframe %>%
  # convert the data frame into a vector
  purrr::map(deframe)

# dataframe with feature data from the molsigdb geneset 
gsva.feat <- genesets %>% 
  dplyr::select(gs_id, gs_cat, gs_subcat, gs_name, gs_exact_source) %>% 
  distinct() %>% 
  mutate(rowname = gs_id) %>% 
  column_to_rownames()

# filtering eset to get unique EntrezIDs and removing NAs
# changing feature names to EntrezIDs
eset2 <- featureFilter(eset, require.entrez = TRUE)
featureNames(eset2) <- fData(eset2)$ENTREZID

# gsva
gsva.es <- gsva(eset2, gs, verbose = FALSE)
fData(gsva.es) <- gsva.feat[featureNames(gsva.es),]

# linear model fit on gsva.es
fit_gsva <- gsva.es %>% 
  lmFit(design) %>% 
  contrasts.fit(contrast.matrix) %>% 
  eBayes()

# toptable function for all genes of all variables
res.gsva <- coefs %>% 
  purrr::map(function(x) {
  topTable(fit_gsva, coef = x, n = Inf)
})

# save res as RDS file
saveRDS(res.gsva,
        file.path(datadir, "/intermediate",
                  paste("tumor",
                        class(res.gsva),
                        "res_gsva.RDS",
                        sep = "_")))

################################################################################

### differential gene expression analysis

# linear model fit on eset
fit_eset <- eset2 %>% 
  lmFit(design) %>% 
  contrasts.fit(contrast.matrix) %>% 
  eBayes()

# toptable function for all genes of all variable
res.eset <- coefs %>%
  purrr::map(function(x) {
    topTable(fit_eset, coef = x, n = Inf)
  })

# save res as RDS file
saveRDS(res.eset,
        file.path(datadir, "/intermediate",
                  paste("tumor",
                        class(res.eset),
                        "res_eset.RDS",
                        sep = "_")))

################################################################################
