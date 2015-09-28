library(xcms)
setwd("/Users/Cody_2/git.repos/brassica_qexactive/data/mzxml/experiment/")

# time infile, use 3 threads
system.time(br_set <- xcmsSet(nSlaves = 3, method = "centWave", ppm = 3, peakwidth = c(5,12)))
   #  user   system  elapsed 
   # 4.326    2.845 7948.286 


br_set <- group(br_set)
br_set2 <- fillPeaks(br_set)
warnings()
#filled in 0 values for out of range 

br_set3 <- groups(br_set2)
p_tab <- peakTable(br_set2)
str(br_set3)

setwd("/Users/Cody_2/git.repos/brassica_qexactive/output/")
write.table(p_tab, "full_rt_int_mv.csv", sep = ",", row.names = FALSE)
head(p_tab)

groupidx1 <- which(br_set3[,"rtmed"] > 440 & br_set3[,"rtmed"] < 442 & br_set3[,"mzmed"] > 610 & br_set3[,"mzmed"] < 612)
groupidx2 <- which(br_set3[,"rtmed"] > 502 & br_set3[,"rtmed"] < 504 & br_set3[,"mzmed"] > 640 & br_set3[,"mzmed"] < 642)
groupidx1
groupidx2