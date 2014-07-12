rDEA
====

Data Envelopment Analysis (DEA) package for R with robust unbiased methods. For linear soptimization rDEA uses GLPK under the hood.

Installation from CRAN
---------------------

The package will be soon published in the official R CRAN.

Installation from git
--------------------

Using **devtools** package our package can be installed by
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

