rm(list = ls())
source('D:/多组学2/SMCCcode/SMCC.R')
library(Rcpp)
library(parallel)
library(Matrix)

library(survival)
library(dplyr)
library(survminer)

setwd("D:/多组学2/SMCCcode/")
# system("R CMD SHLIB projsplx_R.c")
dyn.load("projsplx_R.dll")


library(reticulate)
use_virtualenv("base")
Sys.setenv(RETICULATE_PYTHON="C:\\Users\\ywy\\Anaconda3\\anaconda3\\python.exe")
use_python("C:\\Users\\ywy\\Anaconda3\\anaconda3\\python.exe")
py_config()
py_available()

setwd("D:/多组学2/SMCCcode/")
# input: matirx,k
source_python("score.py")
source_python("label.py")

### data input
setwd("D:/多组学2/SMCCcode/data/TCGA/BIC/data/")
list <- list.files()
data <- data.frame()
data1 <- list()
X <- list()
for(i in list){
  path <- i
  data <- read.csv(file = path, header = TRUE)
  rownames(data) <- data$X
  data <- data[-1]
  data11 <- as.matrix(data)
  data1[[i]] = scale(data11, center=TRUE, scale=TRUE) 
  data2 = t(data1[[i]])
  d1 = dist(data2)
  d1 = as.matrix(d1)
  X[[i]] <- d1
}

# 主成分
Xpca = list()
for(i in 1:3){
  mtcars.pca <- prcomp(t(data1[[i]]), center = F,scale. = F)
  pca_data <- predict(mtcars.pca)
  pca = pca_data[,c(1,2,3)]
  pca1 = as.data.frame(pca)
  pca1 = scale(pca1)
  dd = dist(pca1,method="euclidean")
  Xpca[[i]] = as.matrix(dd)
}

Xall = c(X,Xpca)

c = 4
k = 4
result = SMCC(X = Xall,c = c,k = k)


### log-rank test
setwd("D:/多组学2/SMCCcode/data/TCGA/BIC/")
ss = read.csv('survival.csv')
d = ss[,c(1,2,3)]
colnames(d) = c('name','Survival','Death')
la = result$label
d['x'] = la
ta1 = as.data.frame(table(la))
ta2  = ta1$Freq
# pvalue
sur = survdiff(Surv(Survival, Death) ~ x, data = d)
pvalue <- 1 - pchisq(sur$chisq, length(sur$n) - 1)




