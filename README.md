rDEA
====

Data Envelopment Analysis (DEA) package for R, estimating robust DEA scores
without and with environmental variables and doing returns-to-scale tests.

Installation from CRAN
---------------------
The package will be soon published in the official R CRAN.

Installation from git
--------------------

Using **devtools** our package can be installed by
```R
library(devtools)
install_github("jaak-s/rDEA")
```

In Linux another option is to use command line (make sure you have **slam** package
installed)
```bash
git clone https://github.com/jaak-s/rDEA.git
R CMD build rDEA/
R CMD INSTALL rDEA_*.tar.gz
```

DEA Example
-------------------------
Robust DEA (Simar and Wilson, 1998) with input model with included Japan
hospital data
```R
library(rDEA)
## loading Japan hospital data
data("dea_hospitals", package="rDEA")

## filtering out year 12 data
H12 = subset(dea_hospitals, year == 12)
H12[is.na(H12)] = 0

## choosing inputs and outputs for analysis
firms = 1:50
X = H12[firms, c('x1', 'x2', 'x3', 'x5')]
Y = H12[firms, c('y1', 'y2')]

## Robust DEA with 1000 bootstrap iterations and variable returns-to-scale
di = dea.robust(X=X, Y=Y, model="input", RTS="variable", B=1000)

## robust estimates of technical efficiency for each hospital
di$tehta_hat_hat
```

Testing installed rDEA package
-------------------------
After installing rDEA package you can run included tests by
```R
library(testthat)
library(maxLik)
test_package("rDEA")
```

