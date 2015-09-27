library(xcms)
setwd("/Users/Cody_2/git.repos/brassica_qexactive/data/")

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

br_peaks <- findPeaks.centWave(br_test)
str(br_peaks)
plot(br_peaks$rt, br_peaks$mz)
head(br_peaks)
str(br_peaks)
br_peaks2 <- as.data.frame(br_peaks)
head(br_peaks2)
plot(br_peaks2$rt, br_peaks2$mz)

?xcmsSet
br_set <- xcmsSet(method = "centWave", ppm = 3)
class(br_set)
str(br_set)


# br_set@phenoData$class <- paste(c("H", "L", "pool"))
# br_set@phenoData$class
br_set <- group(br_set)
br_set2 <- fillPeaks(br_set)
str(br_set2)
plot(br_set2)
str(br_set)

br_set3 <- groups(br_set2)
str(br_set3)
head(br_set3)
head(br_set3)

br_set4 <- as.data.frame(br_set3)
plot(br_set4$rtmed, br_set4$mzmed)
groupidx1 <- which(br_set3[,"rtmed"] > 2600 & br_set3[,"rtmed"] < 2700 & br_set3[,"npeaks"] == 5)
groupidx2 <- which(br_set3[,"rtmed"] > 3600 & br_set3[,"rtmed"] < 3700 & br_set3[,"npeaks"] == 5)
groupidx1

eiccor <- getEIC(br_set3, groupidx = c(groupidx1, groupidx2))

?diffreport
br_report <- diffreport(br_set, "high", 1, metlin = 0.15, h=480, w=640)
str(br_set)
br_set
?groups
gt <- groups(br_set)
colnames(gt)
head(gt)