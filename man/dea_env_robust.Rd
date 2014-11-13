\name{dea.env.robust}
\alias{dea.env.robust}
\title{Bias-corrected data envelopment analysis scores in the models with environmental variables}
\description{
  Bias-corrected scores in input- and output-oriented DEA models with environmental (exogenous) variables
}
\usage{
dea.env.robust (X, Y, W=NULL, Z, model, RTS="variable", 
                           L1=100, L2=2000, alpha=0.05)
}
\arguments{
    \item{X}{a numeric vector or matrix of inputs for observations used for estimating DEA scores.}
     \item{Z}{a numeric vector or matrix of environmental variables for observations used for estimating DEA scores, constant should NOT be included.}
    \item{Y}{a numeric vector or  matrix of outputs for observations used for esimating DEA scores.}
  \item{model}{a string variable denoting the type of DEA model to be estimated, "input" for input-oriented model, "output" for output-oriented model, "costmin" for cost-minimization model}
  \item{RTS}{a string variable denoting returns-to-scale under which DEA scores are estimated, "constant" for constant returns-to-scale, "variable" for variable returns-to-scale, "non-increasing" for non-inscreasing returns-to-scale}  
  \item{L1}{a scalar showing the number of bootstrap replications in the first loop of Simar and Wilson's (2007) algorithm, default is L1=100}  
   \item{L2}{a scalar showing the number of bootstrap replications in the second loop of Simar and Wilson's (2007) algorithm}  
    \item{alpha}{a scalar for the size of confidence interval for bias-corrected DEA score} 
}
\details{
  Implements Simar and Wilson's (2007) second algorithm bias-correction of technical efficiency scores in input- and output-oriented DEA models. Computations are done in terms of distance function, i.e. the reciprocal of efficiency score, with the range from one to infinity  
}
\value{
  A list containing bias-corrected scores for each producer, with the following components.
  ## Note to Jaak: please exclude the following from package output- these were used only for ## paper computations
 ## Zbeta_hat_hat, beta_hat_hat_star, sigma_hat_hat_star, delta_hat_hat_used
  \item{delta_hat}{a vector for the reciprocal of DEA efficiency score, estimated in input or output-oriented model in with dea function}
   \item{beta_hat}{a vector or matrix for coefficients in the truncated regression of reciprocal of DEA scores on environmental variables}
  \item{sigma_hat}{a vector for variance of the errors in the truncated regression of reciprocal of DEA scores on environmental variables}
 \item{beta_hat_hat}{a vector or matrix for robust coefficients in the truncated regression of reciprocal of DEA scores on environmental variables (after the second loop)}
  \item{sigma_hat_hat}{a vector for robust variance of the errors in the truncated regression of reciprocal of DEA scores on environmental variables (after the second loop)}
  \item{delta_hat_hat}{a vector for robust reciprocal of DEA efficiency score (after the second loop)}
  \item{bias}{a vector for bias of the reciprocal of DEA efficiency score, bias is non-positive}
  \item{delta_ci_low}{a vector for lower bound of confidence interval for bias-corrected distance function scores}
  \item{delta_ci_high}{a vector for upper bound of confidence interval for bias-corrected distance function score}
 \item{beta_ci}{a matrix of lower and upper bounds of confidence intervals for robust coefficients  in the truncated regression of reciprocal of DEA scores on environmental variables}
 \item{beta_ci}{a matrix of lower and upper bounds of confidence intervals for robust variance of errors in the truncated regression of reciprocal of DEA scores on environmental variables}
}

\references{
Simar, L. and Wilson, P.W. 2007.Estimation and inference in two-stage, semi-parametric models of production processes. Journal of Econometrics. Vol.136, pp.31--64.
 
The Measurement of Productive Efficiency and Productivity Growth. 2008. O'Fried, H. and Lovell, C.A.K. and Schmidt, S.S., eds. Oxford University Press.

Simar, L. and Wilson, P. 2011. Two-stage DEA: caveat emptor. Journal of Productivity Analysis. Vol.36, pp.205--218.

Besstremyannaya, G. 2013. The impact of Japanese hospital financing reform on hospital efficiency. Japanese Economic Review. Vol.64, No.3, pp.337--362.
}
\author{Jaak Simm, Galina Besstremyannaya}
\seealso{
  \code{\link[rDEA]{dea}} and \code{\link[rDEA]{dea.robust}}.
}
\examples{
## loading data on Japanese hospitals in FY 1999 (Besstremyannaya 2013)
data("HospitalData", package="rDEA")

## inputs and outputs for analysis
## annual numbers of inpatients and outpatients in each hospital 
Y = HospitalData[c('inpatients', 'outpatients')]
## labour is total employees, capital is total number of beds
X = HospitalData[c('labor', 'capital')]
## z1 is the number of examinations per 100 patients
Z= HospitalData[c('z1')]

## Naive input-oriented DEA score for the first 50 firms under variable returns-to-scale 
firms=1:50
di_naive = dea(XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], model="input", RTS="variable")
di_naive$thetaOpt

## Bias-corrected DEA score in input-oriented model with environmental variables under variable returns-to-scale
di_env.robust = dea.env.robust(X=X[firms,], Y=Y[firms,], Z=Z[firms,], model="input", RTS="variable", L1, L2=100, alpha=0.05)
di_env.robust$delta_hat_hat
di_env.robust

}
\keyword{DEA, non-parametric efficiency, technical efficiency, cost efficiency}
