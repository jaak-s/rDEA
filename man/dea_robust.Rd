\name{dea.robust}
\alias{dea.robust}
\title{Bias-corrected data envelopment analysis scores}
\description{
  Bias-corrected scores in input- and output-oriented models
}
\usage{
dea.robust (X, Y, W=NULL, model, RTS, B, alpha, bw)
}
\arguments{
  \item{X}{a numeric vector or matrix of inputs for observations used for estimating DEA scores.}
  \item{Y}{a numeric vector or  matrix of outputs for observations used for esimating DEA scores.}
  \item{W}{a matrix of input prices, not used.}
  \item{model}{a string variable denoting the type of DEA model to be estimated, "input" for input-oriented model, "output" for output-oriented model, "costmin" for cost-minimization model}
  \item{RTS}{a string variable denoting returns-to-scale under which DEA scores are estimated, "constant" for constant returns-to-scale, "variable" for variable returns-to-scale, "non-increasing" for non-inscreasing returns-to-scale}  
  \item{B}{a scalar showing the number of bootstrap replications, the default is B=1000}  
  \item{bw}{a string variable for the type of bandwidth used as smoothing parameter in sampling with reflection, "cv" or "bw.ucv" for cross-validation bandwidth, "silverman" or "bw.nrd0" for Silverman's (1986) rule} 
  \item{alpha}{a scalar for the size of confidence interval for bias-corrected DEA score} 
}
\details{
  Implements Simar and Wilson's (1998) bias-correction of technical efficiency scores  in input- and output-oriented DEA models. 
}
\value{
  A list containing bias-corrected scores for each firm, with the following components.
  % ## Later, Note to Jaak: let's include Kneip ci here, too.
  \item{theta_hat_hat}{a vector of bias-corrected DEA score for each firm, theta_hat_hat is in the range of zero to one}
  \item{bias}{a vector of bias for naive DEA scores, bias is non-negative}
  \item{theta_ci_low}{a vector for lower bound of confidence interval for bias-corrected DEA score}
  \item{theta_ci_high}{a vector for upper bound of confidence interval for bias-corrected DEA score}
}

\references{
Silverman, B.W. 1986. Density Estimation for Statistics and Data Analysis.Chapman and Hall, New York.

Simar, L. and Wilson, P.W. 1998. Sensitivity analysis of efficiency scores: how to bootstrap in nonparametric frontier models. Management Science. Vol.44, pp.49--61.

Simar, L. and Wilson, P. 2000. A general methodology for bootstrapping in non-parametric frontier models. Journal of Applied Statistics. Vol.27, No.6, pp.779--802.

Badin, L. and Simar, L. 2003. Confidence intervals for DEA-type efficiency scores: how to avoid the computational burden of the bootstrap. IAP Statistics Network, Technical report 0322, http://sites.uclouvain.be/IAP-Stat-Phase-V-VI/PhaseV/publications\_2003/TR/TR0322.pdf

Kneip, A. and Simar, L. and Wilson, P.W. 2008. Asymptotics and consistent bootstraps for DEA estimators in nonparametric frontier models. Econometric Theory. Vol.24, pp.1663--1697.

Kneip, A. and Simar, L. and Wilson, P.W. 2011. A computationally efficient, consistent bootstrap for inference with non-parametric DEA estimators. Computational Economics. Vol.38, pp.483--515.

Besstremyannaya, G. 2013. The impact of Japanese hospital financing reform on hospital efficiency. Japanese Economic Review. Vol.64, No.3, pp.337--362.
}
\author{Jaak Simm, Galina Besstremyannaya}
\seealso{
  \code{\link[rDEA]{dea}} and \code{\link[rDEA]{dea.env.robust}}.
}
\examples{
## loading data on Japanese hospitals in FY 1999 (Besstremyannaya 2013)
data("hospitals", package="rDEA")

## inputs and outputs for analysis
## annual numbers of inpatients and outpatients in each hospital 
Y = hospitals[c('inpatients', 'outpatients')]
## labour is total employees, capital is total number of beds
X = hospitals[c('labor', 'capital')]

## Naive input-oriented DEA score for the first 50 firms under variable returns-to-scale 
firms=1:50
di_naive = dea(XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], model="input", RTS="variable")
di_naive$thetaOpt

## Bias-corrected DEA score in input-oriented model under variable returns-to-scale
di_robust = dea.robust(X=X[firms,], Y=Y[firms,], model="input", RTS="variable", B, alpha=0.05, bw="cv")
di_robust$theta_hat_hat
di_robust$bias

}
\keyword{DEA, non-parametric efficiency, technical efficiency, cost efficiency}
