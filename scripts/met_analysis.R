# mds analysis
setwd("/Users/Cody_2/git.repos/brassica_qexactive/data")
install.packages("chemometrics")
install.packages("rpart")
library(rpart)
library(chemometrics)

data(wine, package="gclus")
data(NIR)
head(NIR)
str(NIR)
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

?sample
#double check a few seeds
# set.seed(1234)
# set.seed(1456)
# set.seed(56444)
# does not seem to be too sensitive in this data set
set.seed(56444)
s <- 1:4361
s
brass <- sample(s, size = 100, replace = FALSE)
brass
br_data_2 <- br_data_t[,colnames(br_data_t) %in% brass]

dim(br_data_t)
head(br_data_t[4362])

# br_data_2 <- cbind(br_data_2, br_data_t[4362])
dim(br_data_2)
head(br_data_2)

X <- scale(br_data_2[,1:100])
X
res <- pcaCV(X)
head(res)



# non-linear iterative partial least squares
X_nipals <- nipals(X, a = 5, it = 160)
head(X_nipals)

res <- pcaVarexpl(X, a = 5)

X_nipals <- list(scores = X_nipals$T, loadings = X_nipals$P, sdev = apply(X_nipals$T, 2, sd))
resplot <- pcaDiagplot(X, X.pca = X_nipals, a = 5)


X <- scale(br_data_2[,1:100])
X
br_data_2[101] <- as.factor(br_data_2[101])
group <- as.factor(br_data_t[4362])
colnames(group)
str(group)
length(group)
dim(group)
names(group)
group
str(group)

brass2 <- data.frame(X=X, group=group)
set.seed(56444)
train <- as.factor(sample(1:235, round(2/3*235)))
train

?nnetEval
weightse1 <- c(0, 0.01, 0.1, 0.15, 0.2, 0.3, 0.5, 1)
brass_nn <- nnetEval(X, grp = group, train, decay = weightse1, size = 5)



Z <- scale(wine[,2:14])
Z
grp <- as.factor(wine[,1])
grp