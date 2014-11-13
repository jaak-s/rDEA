\name{rts.test}
\alias{rts.test}
\title{Test for returns-to-scale in data envelopment analysis input- and output-oriented models}
\description{
 Tests for returns-to-scale in input- and output-oriented DEA models
 }
 \usage{ 
rts.test(X, Y, W=NULL, model, H0, bw, B, alpha)                          
}
\arguments{
    \item{X}{a numeric vector or matrix of inputs for observations used for estimating DEA scores.}
    \item{Y}{a numeric vector or  matrix of outputs for observations used for esimating DEA scores.}
  \item{model}{a string variable denoting the type of DEA model to be estimated, "input" for input-oriented model, "output" for output-oriented model}
  \item{H0}{a string variable denoting the NULL hypothesis to be tested. "constant" for constant returns-to-scale, "non-increasing" for non-inscreasing returns-to-scale}  
 \item{B}{a scalar showing the number of bootstrap replications in constracting the test staticstics}  
  \item{bw}{a string variable for the type of bandwidth used as smoothing parameter in sampling with reflection, "cv" or "bw.ucv" for cross-validation bandwidth, "silverman" or "bw.nrd0" for Silverman's (1986) rule} 
    \item{alpha}{a scalar for the size of confidence interval for the test statistics} 
}
\details{
  Implements Simar and Wilson's (2002, 2011) returns-to-scale tests for input- and output-oriented DEA models, using ratio of means, mean of ratios or mean of ratios less unity for efficiency scores under the null and the alternative hypotheses as test statistics (denoted respectively, statistics 4.5 and 4.6 in Simar and Wilson (2002) and statistics 48 in Simar and Wilson (2011)).  Tests the null hypothesis of constant returns to scale vs. the alternative hypothesis of variable returns to scale, and the null hypothesis of non-increasing returns to scale vs. the alternative hypothesis of variable returns to scale.
}
\value{
  A list containing the results of returns-to-scale test, with the following components.
  \item{w_hat}{a vector for the values of the test statistics 4.5 after estimations of naive DEA scores}
  \item{w48_hat}{a vector forthe values of the test statistics 48 or statistics 46 after estimations of naive DEA scores}
  \item{D_crs_hat}{a vector for the values of naive DEA scores under the null hypothesis}
    
    ## Note to Jaak: I would rename them theta_H0_hat and theta_vrs_hat
    ## theta, because other parts of package use this notation for DEA score
    ## null subscript, because when we use H0=non-increasing, the code still reports D_crs_hat
    ## Also if B=10, when I do H0="non-increasing" with the attached dataset, I get H0level numeric(0), H048level numeric(0). We should note that number of bootstrap iterations should be greater than 1/alpha, right?
    ##
    
  \item{D_vrs_hat}{a vector for the values of naive DEA scores under the alternative hypothesis}
  \item{w_hat_boot}{a vector for bootstrap values of the test statistics 4.5}
  \item{w48_hat_boot}{a vector for bootstrap values of the test statistics 48 or statistics 46}
  \item{pvalue}{a scalar for p-value in rejecting the hull hypothesis, according to test statistics 4.5}
  \item{pvalue48}{a scalar for p-value in rejecting the hull hypothesis, according to test statistics 4.6 and 48}
  \item{H0reject}{FALSE if H0 is not rejected according to pvalue45 and confidence level alpha, TRUE otherwise}
  \item{H0reject48}{FALSE if H0 is not rejected according to pvalue48 confidence level alpha, TRUE otherwise}
  \item{H0level}{the cut off value of w45_hat_boot for confidence level alpha}
  \item{H0level48}{the cut off value of w48_hat_boot for confidence level alpha}  
  \item{H0}{Null hypothesis tested}
  \item{bw}{type of bandwidth employed}
  \item{bw_value}{value for the bandwidth}
}

\references{
Silverman, B.W. 1986. Density Estimation for Statistics and Data Analysis.Chapman and Hall, New York.

Simar, L. and Wilson, P. 2002. Non-parametric tests of returns to scale. European Journal of Operational Research. Vol.139, No.1, pp.115--132.

The Measurement of Productive Efficiency and Productivity Growth. 2008. O'Fried, H. and Lovell, C.A.K. and Schmidt, S.S., eds. Oxford University Press.

Simar, L. and Wilson, P. 2011. Inference by the m out of n bootstrap in nonparametric frontier models. Journal of Productivity Analysis. Vol.36, pp.33--53.

Besstremyannaya, G. 2013. The impact of Japanese hospital financing reform on hospital efficiency. Japanese Economic Review. Vol.64, No.3, pp.337--362.
}
\author{Jaak Simm, Galina Besstremyannaya}
\seealso{
  \code{\link[rDEA]{dea}}, \code{\link[rDEA]{dea.robust}} and \code{\link[rDEA]{dea.env.robust}}.
}
\examples{
## loading data on Japanese hospitals in FY 1999 (Besstremyannaya 2013)
data("HospitalData", package="rDEA")

## inputs and outputs for analysis
## annual numbers of inpatients and outpatients in each hospital 
Y = HospitalData[c('inpatients', 'outpatients')]
## labour is total employees, capital is total number of beds
X = HospitalData[c('labor', 'capital')]

## Returns-to-scale test in the input-oriented DEA model,
## Testing the null hypothesis of constant returns-to-scale vs. an alternative of variable returns-to-scale
rts_di=rts.test(X=X, Y=Y, W=NULL, model="input", H0="constant", bw="cv", B=100, alpha=0.05)

rts_di.pvalue
rts_di.H0reject
rts_di.H0level
}
\keyword{DEA, non-parametric efficiency, technical efficiency, cost efficiency}
