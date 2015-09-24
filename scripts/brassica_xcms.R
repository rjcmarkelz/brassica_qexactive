library(xcms)
setwd("/Users/Cody_2/git.repos/brassica_qexactive/data/high")

br_test <- xcmsRaw("89.mzXML")
br_test
str(br_test)
head(br_test@scanindex)
br_test@env$mz[810:820]
br_scan1 <- br_test@env$mz[(1+br_test@scanindex[1]):br_test@scanindex[2]]
br_int_scan1 <- br_test@env$intensity[(1+br_test@scanindex[1]):br_test@scanindex[2]]

plot(br_scan1, br_int_scan1, type="h", main=paste("Scan 1 of file", sep=""))
scan1<-getScan(br_test, 1)
head(scan1)
plotScan(br_test, 34)

br_peaks <- findPeaks(br_test)
plot(br_peaks$rt, br_peaks$mz)
head(br_peaks)
str(br_peaks)
br_peaks2 <- as.data.frame(br_peaks)
head(br_peaks2)
plot(br_peaks2$rt, br_peaks2$mz)

?xcmsSet
br_set <- xcmsSet()
str(br_set)
br_set <- findPeaks.centWave(br_set)

# br_set@phenoData$class <- paste(c("H", "L", "pool"))
# br_set@phenoData$class
br_set <- group(br_set)
br_set2 <- fillPeaks(br_set)
plot(br_set)
str(br_set)

?diffreport
br_report <- diffreport(br_set, "high", 1, metlin = 0.15, h=480, w=640)
str(br_set)
br_set
gt <- groups(br_set)
colnames(gt)
head(gt)