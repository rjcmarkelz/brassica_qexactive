library(xcms)
setwd("/Users/Cody_2/git.repos/brassica_qexactive/data/mzxml/experiment/")

# time infile, use 3 threads
system.time(br_set <- xcmsSet(nSlaves = 3, method = "centWave", ppm = 3, peakwidth = c(5,12)))