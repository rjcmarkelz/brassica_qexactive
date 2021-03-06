library(xcms)
setwd("/Users/Cody_2/git.repos/brassica_qexactive/data/test/")

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
system.time(br_set <- xcmsSet(nSlaves = 3, method = "centWave", ppm = 3, peakwidth = c(5,12))) # time 101.7
system.time(br_set <- xcmsSet(method = "centWave", ppm = 3, peakwidth = c(5,12))) # time 197 seconds
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
?group
br_set <- group(br_set)
br_set2 <- fillPeaks(br_set)
str(br_set2)
plot(br_set2)
str(br_set)

# prepare the data to get EIC across the samples
?groups
br_set3 <- groups(br_set2)
class(br_set3)
str(br_set3)
head(br_set3)
head(br_set3)
br_set3
# quick calculations
900/60
7.6*60
8*60
8.4*60

p_tab <- peakTable(br_set2)
head(p_tab)
str(p_tab)
dim(p_tab)
p_tab

br_set4 <- as.data.frame(br_set3)
plot(br_set4$rtmed, br_set4$mzmed)

br_set3
groupidx2
groupidx1 <- which(br_set3[,"rtmed"] > 440 & br_set3[,"rtmed"] < 442 & br_set3[,"mzmed"] > 610 & br_set3[,"mzmed"] < 612)
groupidx2 <- which(br_set3[,"rtmed"] > 502 & br_set3[,"rtmed"] < 504 & br_set3[,"mzmed"] > 640 & br_set3[,"mzmed"] < 642)
groupidx1
groupidx2

?getEIC
eiccor <- getEIC(br_set2, groupidx = c(groupidx1, groupidx2))
eiccor
str(eiccor)

plot(eiccor, br_set2)
test
head(eiccor@eic)


eic_88_q <- as.data.frame(eiccor@eic$`88`[[1]])
eic_88_k <- as.data.frame(eiccor@eic$`88`[[2]])
eic_88_q$sample <- paste("low")
eic_88_k$sample <- paste("low")


eic_89_q <- as.data.frame(eiccor@eic$`89`[[1]])
eic_89_k <- as.data.frame(eiccor@eic$`89`[[2]])
eic_89_q$sample <- paste("high")
eic_89_k$sample <- paste("high")

eic_pool_q <- as.data.frame(eiccor@eic$pool5[[1]])
eic_pool_k <- as.data.frame(eiccor@eic$pool5[[2]])
eic_pool_q$sample <- paste("pool")
eic_pool_k$sample <- paste("pool")
eic_pool_k

eic_q <- as.data.frame(rbind(eic_88_q, eic_89_q, eic_pool_q))
eic_q
colnames(eic_q) <- paste(c("rt", "intensity", "sample"))
names(eic_q)

eic_k <- as.data.frame(rbind(eic_88_k, eic_89_k, eic_pool_k))
eic_k
colnames(eic_k) <- paste(c("rt", "intensity", "sample"))
names(eic_k)

head(eic_k)
?subset
q_sub <- eic_q[which(eic_q$rt > 450 & eic_q$rt < 500),]
dim(q_sub)
q_sub$met <- paste("kaempferol")
k_sub <- eic_k[which(eic_k$rt > 450 & eic_k$rt < 500),]
dim(k_sub)
k_sub$met <- paste("quercetin")

final <- rbind(q_sub, k_sub)
head(final)
final$minutes <- final$rt/60

# ?diffreport
# br_report <- diffreport(br_set, "high", 1, metlin = 0.15, h=480, w=640)
# str(br_set)
# br_set
# ?groups
# gt <- groups(br_set)
# colnames(gt)
# head(gt)

# plotting
library(ggplot2)
library(reshape2)


colnames(p_tab)[9:11] <- paste(c("high", "low", "pool"))
p_tab_melt <- melt(p_tab, id.vars = c("mz", "mzmin", "mzmax", "rt", "rtmin", "rtmax", "npeaks", "test"))
head(p_tab_melt)
tail(p_tab_melt)
p_tab_melt
p_tab_melt$rt_min <- p_tab_melt$rt/60
str(p_tab_melt)

p_tab_melt$geno <- sub("high","R500", p_tab_melt$variable)
p_tab_melt$geno <- sub("low","IMB211", p_tab_melt$geno)
p_tab_melt$geno <- sub("pool","Pool", p_tab_melt$geno)


chrom <- ggplot(p_tab_melt) + 
  geom_line(aes(x = rt_min, y = value), size = 0.4) +
  xlab("Retention Time (min)") + ylab("Intensity") +
  facet_grid(variable ~ .) +
  theme(axis.title.x = element_text(face="bold", size=20),
           axis.text.x  = element_text(face="bold",size=14),
           axis.title.y = element_text(face="bold", size=20),
           axis.text.y  = element_text(face="bold",size=14),
           panel.grid.major = element_blank(),
           panel.grid.minor = element_blank(),
           panel.background = element_blank(),
           panel.border = element_rect(fill = NA, color = "black"),
           strip.text.y = element_text(size = 12, face = "bold"))
chrom

q_plot <- ggplot() + 
  geom_line(data = eic_q, aes(x = rt, y = intensity)) +
  xlab("Retention Time") + ylab("Intensity") +
  facet_grid(sample ~ .) +
  theme(axis.title.x = element_text(face="bold", size=20),
           axis.text.x  = element_text(size=16),
           axis.title.y = element_text(face="bold", size=20),
           axis.text.y  = element_text(size=16)) + 
  scale_x_continuous(limits = c(460, 500))
q_plot

k_plot <- ggplot() + 
  geom_line(data = eic_k, aes(x = rt, y = intensity)) +
  xlab("Retention Time") + ylab("Intensity") +
  facet_grid(sample ~ .) +
  theme(axis.title.x = element_text(face="bold", size=20),
           axis.text.x  = element_text(size=16),
           axis.title.y = element_text(face="bold", size=20),
           axis.text.y  = element_text(size=16)) +
  scale_x_continuous(limits = c(460, 500))
k_plot

final_plot <- ggplot() + 
  geom_line(data = final, aes(x = minutes, y = intensity, color = met), size = 1.5) +
  xlab("Retention Time (mins)") + ylab("Intensity") +
  facet_grid(sample ~ .) +
  theme(axis.title.x = element_text(face="bold", size=20),
           axis.text.x  = element_text(face = "bold", size=14),
           axis.title.y = element_text(face="bold", size=20),
           axis.text.y  = element_text(face = "bold", size=14),
           panel.grid.major = element_blank(),
           panel.grid.minor = element_blank(),
           panel.background = element_blank(),
           panel.border = element_rect(fill = NA, color = "black"),
           strip.text.y = element_text(size = 12, face = "bold"),
           legend.text = element_text(size = 12, face = "bold"),
           legend.title = element_text(size = 12, face = "bold")) +
  scale_color_discrete(name = "Metabolite")
final_plot

