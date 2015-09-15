source("https://bioconductor.org/biocLite.R")
biocLite("xcms")
biocLite("faahKO")

# learn the package
path2file <- system.file("cdf", package = "faahKO")
list.files(path2file, recursive = TRUE)

library(xcms)
cdffiles <- list.files(path2file, recursive = TRUE, full.names = TRUE)
xset <- xcmsSet(cdffiles)
xset
plot(xset)