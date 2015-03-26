\name{dea.env.robust}
\alias{dea.env.robust}
\title{Bias-corrected data envelopment analysis with environmental variables}
\description{
  Estimates bias-corrected efficiency scores in input- and output-oriented DEA models with environmental (exogenous) variables
}
\usage{
dea.env.robust (X, Y, W=NULL, Z, model, RTS="variable",
                L1=100, L2=2000, alpha=0.05)
}
\arguments{
  \item{X}{a matrix of inputs for observations, for which DEA scores are estimated.}
  \item{Y}{a matrix of outputs for observations, for which DEA scores are estimated.}
  \item{W}{a matrix of input prices, not used here.}
  \item{Z}{a matrix of environmental variables for observations, for which DEA scores are estimated. Constant is automatically included in Z.}
  \item{model}{a string for the type of DEA model to be estimated, "input" for input-oriented, "output" for output-oriented, "costmin" for cost-minimization model.}
  \item{RTS}{a string for returns-to-scale under which DEA scores are estimated, RTS can be "constant", "variable" or "non-increasing".}
  \item{L1}{an integer showing the number of bootstrap replications in the first loop of Simar and Wilson's (2007) algorithm, default is 100.}
  \item{L2}{an integer showing the number of bootstrap replications in the second loop of Simar and Wilson's (2007) algorithm, default is 2000.}
  \item{alpha}{a number in (0,1) denoting the size of confidence interval for the bias-corrected DEA score, default is 0.05.}
}
\details{
  Implements Simar and Wilson's (2007) second algorithm for bias-correction of technical efficiency scores in input- and output-oriented DEA models. Computations are done in terms of distance function, i.e. the reciprocal of efficiency score, with the range from one to infinity.
}
\value{
  A list containing bias-corrected scores for each firm, with the following components.
  %## Note to Jaak: please exclude the following from package output- these were used only for ## paper computations
  %## Zbeta_hat_hat, beta_hat_hat_star, sigma_hat_hat_star, delta_hat_hat_used
  \item{delta_hat}{the vector of the reciprocal of DEA score (distance function), estimated in input or output-oriented model in with dea function.}
  \item{beta_hat}{the vector of coefficients in the truncated regression of the reciprocal of DEA score on environmental variables.}
  \item{sigma_hat}{the standard deviation of the errors in the truncated regression of reciprocal of DEA score on environmental variables.}
  \item{beta_hat_hat}{the vector of robust coefficients in the truncated regression of reciprocal of DEA score on environmental variables (after the second loop).}
  \item{sigma_hat_hat}{the robust standard deviation of the errors in the truncated regression of reciprocal of DEA score on environmental variables (after the second loop).}
  \item{delta_hat_hat}{the vector of robust reciprocal of DEA score (after the second loop).}
  \item{bias}{the vector of bias of the reciprocal of DEA score, bias is non-positive.}
  \item{delta_ci_low}{the vector of the lower bounds of confidence interval for bias-corrected reciprocal of DEA score.}
  \item{delta_ci_high}{the vector of the upper bounds of confidence interval for bias-corrected reciprocal of DEA score.}
  \item{beta_ci}{the matrix of lower and upper bounds for beta using \code{alpha} confidence intervals (beta is robust coefficients in the truncated regression of the reciprocal of DEA score on environmental variables).}
  \item{sigma_ci}{the matrix of lower and upper bounds for sigma using \code{alpha} confidence intervals (sigma is the robust standard deviation in the truncated regression of the reciprocal of DEA score on environmental variables).}
}

\references{
Simar, L. and Wilson, P.W. 2007. Estimation and inference in two-stage, semi-parametric models of production processes. Journal of Econometrics. Vol.136, pp.31--64.

The Measurement of Productive Efficiency and Productivity Growth. 2008. O'Fried, H. and Lovell, C.A.K. and Schmidt, S.S., eds. Oxford University Press.

Simar, L. and Wilson, P. 2011. Two-stage DEA: caveat emptor. Journal of Productivity Analysis. Vol.36, pp.205--218.

Besstremyannaya, G. 2011. Managerial performance and cost efficiency of Japanese local public hospitals. Health Economics. Vol.20(S1), pp.19--34.

Besstremyannaya, G. 2013. The impact of Japanese hospital financing reform on hospital efficiency. Japanese Economic Review. Vol.64, No.3, pp.337--362.
}
\author{Jaak Simm, Galina Besstremyannaya}
\seealso{
  \code{\link[rDEA]{dea}}, \code{\link[rDEA]{dea.robust}} and \code{\link[rDEA]{hospitals}}.
}
\examples{
## load data on Japanese hospitals (Besstremyannaya 2013, 2011)
data("hospitals", package="rDEA")
Y = hospitals[c('inpatients', 'outpatients')]
X = hospitals[c('labor', 'capital')]
Z = hospitals[c('z1')]

## Naive input-oriented DEA score for the first 20 firms
## under variable returns-to-scale
firms=1:20
di_naive = dea(XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,],
               model="input", RTS="variable")
di_naive$thetaOpt

## added only for testing of the manual
library(maxLik)

## Bias-corrected DEA score in input-oriented model
## with environmental variables, variable returns-to-scale
di_env = dea.env.robust(
             X=X[firms,], Y=Y[firms,], Z=Z[firms,], model="input",
             RTS="variable", L1, L2=100, alpha=0.05)
di_env$delta_hat_hat

}
\keyword{DEA, non-parametric efficiency, technical efficiency, cost efficiency}
