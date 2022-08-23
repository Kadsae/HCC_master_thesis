### script for pre-processing and normalizing data for the master thesis ###
### Author: Florian Himmelbauer                                          ###

# load needed libraries
library(ArrayExpress)
library(affy)
library(arrayQualityMetrics)
library(here)
library(rat2302.db)

# assign variables to needed directories
datadir <- "../data/rat_data"
resultsdir <- "../results/"

# loading in pdata and assigning file names to rownames
pdata <- read.delim(file.path(datadir, "pdata.csv"),
                    sep=";",
                    stringsAsFactors = FALSE)
rownames(pdata) <- pdata$CEL

# write vector with file names
file.names <- list.files(datadir, pattern=".CEL")

# construct affybatch
abatch <- ReadAffy(filenames = file.path(datadir, file.names), sampleNames = file.names)

# attach pdata to abatch
pData(abatch) <- pdata[sampleNames(abatch),]

################################################################################

# do the QC for the Affybatch
QC <- arrayQualityMetrics(abatch,
                          do.logtransform = TRUE,
                          force = TRUE,
                          outdir = file.path(resultsdir, "QC.abatch"))

outliers <- lapply(QC$modules,
                   function(x){
                     x@outliers@which
                   })

outliers <- unique(unlist(outliers))
outliers <- c(2, 3, 14, 15) # we only delete those outliers that are detected in the Spatial Distribution Plots
goodSamples <- setdiff(c(1:length(abatch)), outliers)
abatch.outlierremoved <- abatch[,goodSamples]

rm(QC)

# normalize the Affybatch
eset <- rma(abatch.outlierremoved,
            verbose = TRUE)

# annotate the probes
fdata <- createAnnotation(annotation(eset))
fData(eset) <- fdata[featureNames(eset),]

saveRDS(eset,
        file.path(datadir, "/intermediate",
                        paste("tumor",
                              class(eset),
                              "raw.RDS",
                              sep="_")))

# do QC and remove remaining outliers
QC <- arrayQualityMetrics(eset,
                          do.logtransform = FALSE,
                          force = TRUE,
                          outdir = file.path(resultsdir, "QC.eset"))

outliers <- lapply(QC$modules,
                   function(x){
                     x@outliers@which
                   })

outliers <- unique(unlist(outliers)) 
outliers <- c() # we remove nothing as these outliers don't bother us
goodSamples <- setdiff(c(1:ncol(eset)), outliers)
eset.outlierremoved <- eset[,goodSamples]

# save the eset
saveRDS(eset.outlierremoved, 
        file.path(datadir, "/intermediate", 
                  paste("tumor", 
                        class(eset.outlierremoved), 
                        "outlierremoved.RDS",
                        sep = "_")))

#rm(eset)
#rm(abatch)

################################################################################

# BiocManager::install("rat2302.db") needed for createAnnotation function to work
# createAnnotation creates a dataframe mapping ProbeIDs to Annotations such as ENTREZID, SYMBOL, etc.
# call: annotation <- createAnnotation(columns, annotation)
# columns: columns of the annotation package
# annotation: annotation package as returned by annotation(eset)
# (c) ScienceConsult - DI Thomas Mohr KG (Thomas Mohr) 2016, licensed under GPL

createAnnotation <- function(annotation, columns = c("ACCNUM",
                                                     "ENTREZID", 
                                                     "ENSEMBL",
                                                     "ENSEMBLTRANS",
                                                     "REFSEQ",
                                                     "SYMBOL", 
                                                     "GENENAME",
                                                     "UNIPROT"),
                             keytype = "PROBEID",
                             keys = NULL){
  package <- paste(annotation, "db", sep = ".")
  require(package, character.only = TRUE)
  DBObject <- get(package)
  names(columns) <- columns
  if (is.null(keys)){
    keys <- keys(DBObject, keytype = keytype)
  }
  coerce <- function(x){
    paste(x, collapse = ", ")
  }
  mapping <- lapply(columns, 
                    function(column, DBObject, keys, keytype, multiVals){
                      map <- mapIds(x = DBObject, 
                                    keys = keys, 
                                    column = column, 
                                    keytype = keytype, 
                                    multiVals = multiVals)
                      return(map)
                    },
                    DBObject = DBObject,
                    keys = keys,
                    keytype = keytype,
                    multiVals = function(x){
                      paste(x, collapse = ", ")
                    })
  mapping <- data.frame(PROBEID = keys,
                        mapping,
                        stringsAsFactors = FALSE)
  return(mapping)
}

################################################################################
