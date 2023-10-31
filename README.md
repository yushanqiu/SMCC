### Environment: 
Anaconda, R>= 4.1.0;
### R package: 
Rcpp;   parallel;  Matrix; reticulate >= 1.22; survival; dplyr; survminer; 
### Introduction: 
The algorithm is implemented by Python and R.  You need to install the Anaconda environment and Rstudio, and the R version used in this experiment is 4.1.0.  The source code is mainly written in R.  The experimental datasets are stored in the folder "data", which contains noise datasets, single cell dataset kolod and TCGA datasets BIC. The steps are as follows：

###### Import SMCC algorithms from data sources.  
> source('../SMCCcode/SMCC.R')   
###### Import the projsplx_r.dll file.
> setwd("../SMCCcode/")    
> dyn.load("projsplx_R.dll")  
##### If that fails, you can run the following code.
> system("R CMD SHLIB projsplx_R.c")  
##### Connect Anaconda environment.
> library(reticulate)  
> use_virtualenv("base")  
> Sys.setenv(RETICULATE_PYTHON="C:\\Users\\*\\anaconda3\\python.exe")   
> use_python("C:\\Users\\*\\anaconda3\\python.exe")  
> py_config()  
> py_available()  
##### If the command is successfully executed, TRUE is displayed. Then import the Python files.
> source_python("score.py")  
> source_python("label.py") 
###### Where, score.py is the file that calculates ARI and NMI, and label.py is the file that gets the label after clustering. 
##### Here, we create three demo to analyze three different datasets. Run demo_noise.R file, you can obtain the label and ARI/NMI scores of noise dataset. Run demo_single.R file, you can obtain the label and ARI/NMI scores of single cell dataset.  Run demo_multiomics.R file, you can obtain the label and pvalue of multiomics dataset.
###### If you have true label, you can run
> result = SMCC(X = Xall,c = c,k = k)
###### If you do not have true label, you can run
> result = SMCC(X = Xall,c = c,k = k, label_path = label_path, label_col = label_col)
###### Here, label_path is the path of your true label and label_col is the column name of true label.

