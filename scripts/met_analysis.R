# mds analysis
setwd("/Users/Cody_2/git.repos/brassica_qexactive/data")
install.packages("chemometrics")
library(chemometrics)

data(wine, package="gclus")
head(wine)
tail(wine)
str(wine)
X <- scale(wine[,2:14])
X
res <- pcaCV(X)
dim(wine)

?read.csv
br_names <- read.csv("genotype_assignment_qexactive.csv", header = TRUE)
setwd("/Users/Cody_2/git.repos/brassica_qexactive/output/")
br_data  <- read.csv("full_rt_int_mv.csv", header = TRUE)
head(br_names)
head(br_data)

dim(br_data)
br_data_red <- br_data[9:243]
head(br_data_red)
dim(br_data_red)

br_data_red$feature <- rownames(br_data_red)
br_data_red$feature
dim(br_data_red)
br_data_names <- as.data.frame(br_data_red[236])
head(br_data_names)
br_data_red <- br_data_red[-c(236)]
head(br_data_red)
br_data_t <- as.data.frame(t(br_data_red))
head(br_data_t)
colnames(br_data_t) <- br_data_names[,1]

br_data_t[4199] # hello!

br_data_t$geno <- rownames(br_data_t)
head(br_data_t)
br_data_t$geno <- sub('X', '', br_data_t$geno)
br_data_t$geno <- as.numeric(br_data_t$geno)

br_data_t <- merge(br_data_t, br_names, by.x = 'geno', by.y = 'Plant', all.x = TRUE)
head(br_data_t)
br_data_t <- br_data_t[-1]
br_data_t <- br_data_t[-4363]
dim(br_data_t)

str(br_data_t)

X <- scale(br_data_t[,1:4361])
X
res <- pcaVarexpl(X, a=5)

plot(pca(X))
