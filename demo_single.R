rm(list = ls())
source('D:/多组学2/SMCCcode/SMCC.R')
library(Rcpp)
library(parallel)
library(Matrix)

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
data = read.csv('D:/多组学2/SMCCcode/data/singlecell/kolod.csv')
data <- data[-1]
data11 <- as.matrix(data)
data1 = scale(data11, center=TRUE, scale=TRUE) 
data2 = t(data1)
d1 = dist(data2)
d1 = as.matrix(d1)
X <- d1

### pca
mtcars.pca <- prcomp(t(data1), center = F,scale. = F)
pca_data <- predict(mtcars.pca)
pca = pca_data[,c(1,2,3)]
pca1 = as.data.frame(pca)
pca1 = scale(pca1)
dd = dist(pca1,method="euclidean")
Xpca = as.matrix(dd)

Xall = list(X,Xpca)
c = 3
k = 10
label_path = 'D:/多组学2/SMCCcode/data/singlecell/kolod_label.csv'
label_col = 'V1'
result = SMCC(X = Xall,c = c,k = k)
result = SMCC(X = Xall,c = c,k = k, label_path = label_path, label_col = label_col)



