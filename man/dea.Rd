\name{dea}
\alias{dea}
\title{Data envelopment analysis scores}
\description{
  Naive scores in input-oriented, output-oriented and cost-minimization DEA models
}
\usage{
dea(XREF, YREF, X, Y, W=NULL, model, RTS="variable")
}
\arguments{
  \item{XREF}{a matrix of inputs for observations used for constructing the frontier.}
  \item{YREF}{a matrix of outputs for observations used for constructing the frontier.}
   \item{X}{a matrix of inputs for observations used for estimating DEA scores.}
   \item{W}{a matrix of input prices for observations used for estimating DEA scores in cost-minimization model, W=NULL for input- and output-oriented models.}
  \item{Y}{a matrix of outputs for observations used for esimating DEA scores.}
  \item{model}{a string for the type of DEA model to be estimated, "input" for input-oriented, "output" for output-oriented, "costmin" for cost-minimization model.}
  \item{RTS}{a string for returns-to-scale under which DEA scores are estimated, RTS can be "constant", "variable" or"non-increasing".}  
}
\details{
  Estimates technical efficiency scores (input- and output-oriented DEA models) and cost efficiency score (cost-minimization DEA).
}
\value{
  A list containing the optimal solutions for linear optimization problem for each firm,
  with the following components.
  \item{thetaOpt}{a vector of DEA scores in input- or output-oriented model, thetaOpt is in the range of zero to one}
  \item{gammaOpt}{a vector of DEA scores in cost-minimization model}
  
  %##note to Jaak: in the current version it is Xopt, lower case o, needs to be renamed
  
  \item{XOpt}{a matrix of optimal values of inputs, only returned for cost-minimization model}
  %\item{feasible}{a vector of logical values, equals \code{TRUE} if DEA scores have been estimated}
  \item{lambda}{a matrix of values for constraint coefficients in corresponding linear optimization problem, lambda >=0}
  \item{lambda_sum}{a vector for sum of constraint coefficients in corresponding linear optimization problem, lamdba_sum=1 in case of variable returns-to-scale, lambda_sum <=1 for non-increasing returns-to-scale}
}
\references{
Charnes, A. and Cooper, W. and Rhodes, E. 1978. Measuring the efficiency of decision making units. European Journal of Operational Research. Vol.2, pp.429--444.

Fare, R. and Grosskopf, S. and Lovell, C.A. 1985.The Measurement of Efficiency in Production. Kluwer Academic Publishers.

Coelli, T.J. and Rao, D.S.P. and Battese, G.E. 1994. An Introduction to Efficiency and Productivity Analysis. Kluwer Academic Publishers.

The Measurement of Productive Efficiency and Productivity Growth. 2008. O'Fried, H. and Lovell, C.A.K. and Schmidt, S.S., eds. Oxford University Press.

Besstremyannaya, G. 2013. The impact of Japanese hospital financing reform on hospital efficiency. Japanese Economic Review. Vol.64, No.3, pp.337--362.
}

\author{Jaak Simm, Galina Besstremyannaya}
\seealso{
  \code{\link[rDEA]{dea.robust}} and \code{\link[rDEA]{dea.env.robust}}.
}
\examples{
## load data on Japanese hospitals for FY 1999(Besstremyannaya 2013)
data("hospitals", package="rDEA")

## inputs and outputs for analysis
## annual numbers of inpatients and outpatients in each hospital 
Y = hospitals[c('inpatients', 'outpatients')]
## labour is total employees, capital is total number of beds
X = hospitals[c('labor', 'capital')]
## labor price is per capita annual salary (th.yen) 
## capital price is the sum of depreciation and interest per bed (th.yen)
W = hospitals[c('labor_price', 'capital_price')]

## Naive input-oriented DEA score for the first 50 firms under variable returns-to-scale 
firms=1:50
di_naive = dea(XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], model="input", RTS="variable")
di_naive$thetaOpt

## Naive DEA score in cost-minimization model for the first 50 firms under variable returns-to-scale 
ci_naive = dea(XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,],W=W[firms,], model="costmin", RTS="variable")
ci_naive$XOpt
ci_naive$gammaOpt

}
\keyword{DEA, non-parametric efficiency, technical efficiency, cost efficiency}
