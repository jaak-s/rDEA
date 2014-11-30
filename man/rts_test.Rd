\name{rts.test}
\alias{rts.test}
\title{Test for returns-to-scale in data envelopment analysis}
\description{
 Tests for returns-to-scale in input- and output-oriented DEA models
 }
 \usage{
rts.test(X, Y, W=NULL, model, H0, bw, B, alpha)
}
\arguments{
  \item{X}{a matrix of inputs for observations, for which DEA scores are estimated.}
  \item{Y}{a matrix of outputs for observations, for which DEA scores are estimated.}
  \item{W}{a matrix of input prices, not used.}
  \item{model}{a string for the type of DEA model to be estimated, "input" for input-oriented, "output" for output-oriented model.}
  \item{H0}{a string for the NULL hypothesis to be tested, "constant" for constant returns-to-scale, "non-increasing" for non-inscreasing returns-to-scale.}
  \item{bw}{a string for the type of bandwidth used as a smoothing parameter in sampling with reflection, "cv" or "bw.ucv" for cross-validation bandwidth, "silverman" or "bw.nrd0" for Silverman's (1986) rule.}
  \item{B}{an integer showing the number of bootstrap replications in constracting the test staticstics. Recommended is 100.}
  \item{alpha}{a number in (0,1) for the size of confidence interval for the test statistics.}
}
\details{
  Implements Simar and Wilson's (2002, 2011) returns-to-scale tests for input- and output-oriented DEA models, using ratio of means, mean of ratios or mean of ratios less unity of DEA scores under the null and the alternative hypotheses as test statistics (denoted respectively, statistics 4.5 and 4.6 in Simar and Wilson (2002) and statistics 48 in Simar and Wilson (2011)).  Tests the null hypothesis of constant returns to scale vs. the alternative hypothesis of variable returns to scale, and the null hypothesis of non-increasing returns to scale vs. the alternative hypothesis of variable returns to scale.
}
\value{
  A list containing the results of returns-to-scale test, with the following components.
  \item{w_hat}{the vector for the values of the test statistics 4.5.}
  \item{w48_hat}{the vector for the values of the test statistics 48 or statistics 4.6.}
  \item{theta_H0_hat}{the vector for the values of naive DEA scores under the Null hypothesis (H0).}
  \item{theta_vrs_hat}{the vector for the values of naive DEA scores under the alternative hypothesis.}
  \item{w_hat_boot}{the vector for bootstrap values of the test statistics 4.5.}
  \item{w48_hat_boot}{the vector for bootstrap values of the test statistics 48 or statistics 46.}
  \item{pvalue}{the p-value for rejecting the Null hypothesis, according to test statistics 4.5.}
  \item{pvalue48}{the p-value for rejecting the Null hypothesis, according to test statistics 4.6 and 48.}
  \item{H0reject}{FALSE if H0 is not rejected according to pvalue45 and confidence level alpha, TRUE otherwise.}
  \item{H0reject48}{FALSE if H0 is not rejected according to pvalue48 and confidence level alpha, TRUE otherwise.}
  \item{H0level}{the cut-off value of w45_hat_boot for confidence level alpha.}
  \item{H0level48}{the cut-off value of w48_hat_boot for confidence level alpha.}
  \item{H0}{the Null hypothesis tested.}
  \item{bw}{the type of bandwidth employed.}
  \item{bw_value}{the value for the bandwidth.}
}

\references{
Silverman, B.W. 1986. Density Estimation for Statistics and Data Analysis.Chapman and Hall, New York.

Simar, L. and Wilson, P. 2002. Non-parametric tests of returns to scale. European Journal of Operational Research. Vol.139, No.1, pp.115--132.

The Measurement of Productive Efficiency and Productivity Growth. 2008. O'Fried, H. and Lovell, C.A.K. and Schmidt, S.S., eds. Oxford University Press.

Simar, L. and Wilson, P. 2011. Inference by the m out of n bootstrap in nonparametric frontier models. Journal of Productivity Analysis. Vol.36, pp.33--53.

Besstremyannaya, G. 2011. Managerial performance and cost efficiency of Japanese local public hospitals. Health Economics. Vol.20(S1), pp.19--34.

Besstremyannaya, G. 2013. The impact of Japanese hospital financing reform on hospital efficiency. Japanese Economic Review. Vol.64, No.3, pp.337--362.
}
\author{Jaak Simm, Galina Besstremyannaya}
\seealso{
  \code{\link[rDEA]{dea}}, \code{\link[rDEA]{dea.robust}}, \code{\link[rDEA]{dea.env.robust}} and \code{\link[rDEA]{hospitals}}.
}
\examples{
## load data on Japanese hospitals (Besstremyannaya 2013, 2011)
data("hospitals", package="rDEA")
firms = 1:50
Y = hospitals[firms, c('inpatients', 'outpatients')]
X = hospitals[firms, c('labor', 'capital')]

## Returns-to-scale test in the input-oriented DEA model,
## Testing the null hypothesis of constant returns-to-scale
## vs. an alternative of variable returns-to-scale
rts_di=rts.test(X=X, Y=Y, W=NULL, model="input", H0="constant",
                bw="cv", B=100, alpha=0.05)

rts_di$pvalue
rts_di$H0reject
rts_di$H0level
}
\keyword{DEA, non-parametric efficiency, technical efficiency, cost efficiency}
