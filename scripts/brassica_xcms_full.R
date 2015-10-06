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
head(p_tab)[1:10]
p_tab[1:6,1:10] 
p_tab


groupidx1 <- which(br_set3[,"rtmed"] > 500 & br_set3[,"rtmed"] < 510 & br_set3[,"mzmed"] > 610 & br_set3[,"mzmed"] < 612)
groupidx2 <- which(br_set3[,"rtmed"] > 490 & br_set3[,"rtmed"] < 492 & br_set3[,"mzmed"] > 640 & br_set3[,"mzmed"] < 642)
groupidx1
groupidx2

eiccor <- getEIC(br_set2, groupidx = c(groupidx1, groupidx2))
eiccor

plot(eiccor, br_set2)


setwd("/Users/Cody_2/git.repos/brassica_qexactive/data/absorbance")
UV_641 <- read.table("641abs_clean.csv", sep = ",", header = TRUE)
UV_611 <- read.table("611abs_clean.csv", sep = ",", header = TRUE)
head(UV_641)

plot(UV_641)
plot(UV_611)

UV_merged <- merge(UV_641, UV_611, by = "Wavelength")
UV_merged

library(ggplot2)
library(reshape2)
colnames(UV_merged)[2:3] <- paste(c("Quercetin", "Kaempferol"))
UV_melt <- melt(UV_merged, id.vars = c("Wavelength"))
head(UV_melt)


abs_plot <- ggplot(UV_melt) + 
  geom_line(aes(x = Wavelength, y = value, color = variable), size = 1) +
  xlab("Wavelength") + ylab("Absorbance") +
  # facet_grid(variable ~ .) +
  # scale_x_continuous(limits = c(400, 450)) 
  theme(axis.title.x = element_text(face="bold", size=20),
           axis.text.x  = element_text(face="bold",size=14),
           axis.title.y = element_text(face="bold", size=20),
           axis.text.y  = element_text(face="bold",size=14),
           panel.grid.major = element_blank(),
           panel.grid.minor = element_blank(),
           panel.background = element_blank(),
           panel.border = element_rect(fill = NA, color = "black"),
           strip.text.y = element_text(size = 12, face = "bold"))
abs_plot


