source("https://bioconductor.org/biocLite.R")
biocLite("xcms")
biocLite("faahKO")

# learn the package
path2file <- system.file("cdf", package = "faahKO")
list.files(path2file, recursive = TRUE)

library(xcms)
cdffiles <- list.files(path2file, recursive = TRUE, full.names = TRUE)
xset <- xcmsSet(cdffiles)
str(xset)
plot(xset)

?xcms

xset <- group(xset)

#retention time correction
xset2 <- retcor(xset, family = "symmetric", plottype = "mdevden")
xset2 <- group(xset2, bw = 10)
xset3 <- fillPeaks(xset2)
xset3

reporttab <- diffreport(xset3, "WT", "KO", "example", 10, metlin = 0.15, h = 480, w = 640)
str(reporttab)
reporttab[1:4, ]

gt <- groups(xset3)
colnames(gt)
groupidx1 <- which(gt[,"rtmed"] > 2600 & gt[,"rtmed"] < 2700 & gt[,"npeaks"] == 12)
groupidx2 <- which(gt[,"rtmed"] > 3600 & gt[,"rtmed"] < 3700 & gt[,"npeaks"] == 12)
eiccor <- getEIC(xset3, groupidx = c(groupidx1, groupidx2))
eicraw <- getEIC(xset3, groupidx = c(groupidx1, groupidx2), rt = "raw")

plot(eicraw, xset3, groupidx = 1)
plot(eicraw, xset3, groupidx = 2)
plot(eiccor, xset3, groupidx = 1)
plot(eiccor, xset3, groupidx = 2)