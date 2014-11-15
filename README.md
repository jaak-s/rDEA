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

In Linux and Mac another option is to use command line (make sure you have **slam**, **truncreg** and **truncnorm** R packages installed)
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
data("hospitals", package="rDEA")

## choosing inputs and outputs for analysis
firms = 1:50
Y = hospitals[firms, c('inpatients', 'outpatients')]
X = hospitals[firms, c('labor', 'capital')]

## Robust DEA with 1000 bootstrap iterations and variable returns-to-scale
di = dea.robust(X=X, Y=Y, model="input", RTS="variable", B=1000)

## robust estimates of technical efficiency for each hospital
di$theta_hat_hat
```

Testing installed rDEA package
-------------------------
After installing rDEA package you can run included tests by
```R
library(testthat)
test_package("rDEA")
```

