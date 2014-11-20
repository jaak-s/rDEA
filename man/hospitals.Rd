\name{hospitals}
\docType{data}
\alias{hospitals}
\title{Data on Japanese local public hospitals}
\description{
Administrative dataset for financial variables and selected characteristics of Japanese local public hospitals. Processed for fiscal year 1999 (Heisei 11) and exploited in Besstremyannaya (2013, 2011)
}
\usage{hospitals}
\format{
The processed dataset contains anonymous observations for 958 local public hospitals, identified by a researcher-generated variable "firm_id". Hospital outputs are annual numbers of inpatients and outpatients, denoted, "inpatients" and "outpatients", respectively. Hospital inputs are "labour" (total number of employees) and "capital" (total number of beds). The price of labor is  per capita annual salary (th.yen) and the price of capital is the sum of depreciation and interest per bed (th.yen). Corresponding variable names are "labor_price" and "capital_price". A vector of environmental variables (z1) is the number of examinations per 100 patients.
}
\examples{
data("hospitals", package="rDEA")
Y = hospitals[c('inpatients', 'outpatients')]
X = hospitals[c('labor', 'capital')]
W = hospitals[c('labor_price', 'capital_price')]
Z= hospitals[c('z1')]

## DEA score in input-oriented model
firms=1:20
di_naive = dea(XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], model="input", RTS="variable")
di_naive$thetaOpt

## added only for testing of the manual
library(maxLik)

## robust DEA score in input-oriented model with environmental inputs
di_env = dea.env.robust(X=X[firms,], Y=Y[firms,], Z=Z[firms,],
                        model="input", RTS="variable", L1, L2=100, alpha=0.05)
di_env$delta_hat_hat

## DEA score in cost-minimization model
ci_naive = dea(XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], W=W[firms,],
               model="costmin", RTS="variable")
ci_naive$XOpt
ci_naive$gammaOpt
}

\references{
Besstremyannaya, G. 2011. Managerial performance and cost efficiency of Japanese local public hospitals. Health Economics. Vol.20(S1), pp.19--34.

Besstremyannaya, G. 2013. The impact of Japanese hospital financing reform on hospital efficiency. Japanese Economic Review. Vol.64, No.3, pp.337--362.
}
