library(xcms)
setwd("/Users/Cody_2/git.repos/brassica_qexactive/data/")

# infile a test file
# this high resolution LC/MS data has multiple layers in how it is collected by the q_exactive
# each file contains multiple scans across the sensitivity range for each retention time
# Each scan, or the data file is an intensity value across the m/z range
# Extracted ion chromatograms take for a retention time range certain mass value ranges and thier intensities 
# across the range

# infile individual file to take a look
br_test <- xcmsRaw("89.mzXML")
br_test
str(br_test)

# take a look at an individual scan
head(br_test@scanindex)
br_test@env$mz[810:820]
br_scan1 <- br_test@env$mz[(1+br_test@scanindex[1]):br_test@scanindex[2]]
br_int_scan1 <- br_test@env$intensity[(1+br_test@scanindex[1]):br_test@scanindex[2]]
plot(br_scan1, br_int_scan1, type="h", main=paste("Scan 1 of file", sep=""))

# shorter way to extract this data
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

# here we are pulling out all the data from multiple files at the same time
# we make a set object from centroided data (smaller), from the q_exactive data
?xcmsSet
br_set <- xcmsSet(method = "centWave", ppm = 3)
class(br_set)
str(br_set)


# this is me playing with the object trying to include the meta data about each file in the 
# set object. S4 objects are harder to modify in place without methods. Better to infile this 
# data and include the meta-data for each sample at that time
# need to figure this out
# br_set@phenoData$class <- paste(c("H", "L", "pool"))
# br_set@phenoData$class

# group the data based on peaks that it detects and then fill 
# in values for the missing peaks so you can run stats between samples
# 
br_set <- group(br_set)
br_set2 <- fillPeaks(br_set)
str(br_set2)
plot(br_set2)
str(br_set)

# prepare the data to get EIC across the samples
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