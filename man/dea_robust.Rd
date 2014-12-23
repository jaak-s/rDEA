\name{dea.robust}
\alias{dea.robust}
\title{Bias-corrected data envelopment analysis}
\description{
  Estimates bias-corrected scores for input- and output-oriented models
}
\usage{
dea.robust (X, Y, W=NULL, model, RTS="variable", B=1000, alpha=0.05, 
            bw="bw.ucv", bw_mult=1)
}
\arguments{
  \item{X}{a matrix of inputs for observations, for which DEA scores are estimated.}
  \item{Y}{a matrix of outputs for observations, for which DEA scores are estimated.}
  \item{W}{a matrix of input prices, not used here.}
  \item{model}{a string for the type of DEA model to be estimated, "input" for input-oriented, "output" for output-oriented, "costmin" for cost-minimization model.}
  \item{RTS}{a string for returns-to-scale under which DEA scores are estimated, RTS can be "constant", "variable" or "non-increasing".}
  \item{B}{an integer showing the number of bootstrap replications, the default is B=1000.}
  \item{alpha}{a number in (0,1) for the size of confidence interval for the bias-corrected DEA score.}
  \item{bw}{a string for the type of bandwidth used as a smoothing parameter in sampling with reflection, "cv" or "bw.ucv" for cross-validation bandwidth, "silverman" or "bw.nrd0" for Silverman's (1986) rule.}
  \item{bw_mult}{bandwidth multiplier, default is 1 that means no change.}
}
\details{
  Implements Simar and Wilson's (1998) bias-correction of technical efficiency scores  in input- and output-oriented DEA models.
}
\value{
  A list containing bias-corrected scores for each firm, with the following components.
  % ## Later, Note to Jaak: let's include Kneip ci here, too.
  \item{theta_hat_hat}{the vector of bias-corrected DEA score for each firm, theta_hat_hat is in the range of zero to one.}
  \item{bias}{the vector of bias for naive DEA scores, bias is non-negative.}
  \item{theta_ci_low}{the vector for the lower bounds of confidence interval for bias-corrected DEA score.}
  \item{theta_ci_high}{the vector for the upper bounds of confidence interval for bias-corrected DEA score.}
}

\references{
Silverman, B.W. 1986. Density Estimation for Statistics and Data Analysis.Chapman and Hall, New York.

Simar, L. and Wilson, P.W. 1998. Sensitivity analysis of efficiency scores: how to bootstrap in nonparametric frontier models. Management Science. Vol.44, pp.49--61.

Simar, L. and Wilson, P. 2000. A general methodology for bootstrapping in non-parametric frontier models. Journal of Applied Statistics. Vol.27, No.6, pp.779--802.

Badin, L. and Simar, L. 2003. Confidence intervals for DEA-type efficiency scores: how to avoid the computational burden of the bootstrap. IAP Statistics Network, Technical report 0322, http://sites.uclouvain.be/IAP-Stat-Phase-V-VI/PhaseV/publications_2003/TR/TR0322.pdf

Kneip, A. and Simar, L. and Wilson, P.W. 2008. Asymptotics and consistent bootstraps for DEA estimators in nonparametric frontier models. Econometric Theory. Vol.24, pp.1663--1697.

Kneip, A. and Simar, L. and Wilson, P.W. 2011. A computationally efficient, consistent bootstrap for inference with non-parametric DEA estimators. Computational Economics. Vol.38, pp.483--515.

Besstremyannaya, G. 2011. Managerial performance and cost efficiency of Japanese local public hospitals. Health Economics. Vol.20(S1), pp.19--34.

Besstremyannaya, G. 2013. The impact of Japanese hospital financing reform on hospital efficiency. Japanese Economic Review. Vol.64, No.3, pp.337--362.
}
\author{Jaak Simm, Galina Besstremyannaya}
\seealso{
  \code{\link[rDEA]{dea}}, \code{\link[rDEA]{dea.env.robust}} and \code{\link[rDEA]{hospitals}}.
}
\examples{
## load data on Japanese hospitals (Besstremyannaya 2013, 2011)
data("hospitals", package="rDEA")
Y = hospitals[c('inpatients', 'outpatients')]
X = hospitals[c('labor', 'capital')]

## Naive input-oriented DEA score for the first 20 firms under variable returns-to-scale
firms=1:20
di_naive = dea(XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,],
               model="input", RTS="variable")
di_naive$thetaOpt

## Bias-corrected DEA score in input-oriented model under variable returns-to-scale
di_robust = dea.robust(X=X[firms,], Y=Y[firms,], model="input",
                       RTS="variable", B, alpha=0.05, bw="cv")
di_robust$theta_hat_hat
di_robust$bias

}
\keyword{DEA, non-parametric efficiency, technical efficiency, cost efficiency}
