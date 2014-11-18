\name{multi_glpk_solve_LP}
\alias{multi_glpk_solve_LP}
\title{Multi Problem Solver for Linear and Mixed Integer Programming Using GLPK}
\description{
  High level R interface to the GNU Linear Programming Kit (GLPK) for solving
  multiple linear as well as mixed integer linear programming (MILP) problems.
  Solving multiple problems at the same time allows to avoid R communication
  overhead, critical when solving many small problems.
}
\usage{
multi_glpk_solve_LP(obj, mat, dir, rhs, bounds = NULL, types = NULL, max = FALSE,
          control = list(),
          mobj_i = NULL, mobj_val = NULL,
          mmat_i = NULL, mmat_val = NULL,
          mrhs_i = NULL, mrhs_val = NULL,
          \ldots)
}
\arguments{
  \item{obj}{a numeric vector representing the objective coefficients.}
  \item{mat}{a numeric vector or a matrix of constraint coefficients.}
  \item{dir}{a character vector with the directions of the constraints.
    Each element must be one of \code{"<"}, \code{"<="}, \code{">"},
    \code{">="}, or \code{"=="}.}
  \item{rhs}{the right hand side of the constraints.}
  \item{bounds}{\code{NULL} (default) or a list with elements
    \code{upper} and \code{lower} containing the indices and
    corresponding bounds of the objective variables.  The default for
    each variable is a bound between 0 and \code{Inf}.}
  \item{types}{a character vector indicating the types of the objective
    variables. \code{types} can be either \code{"B"} for binary,
    \code{"C"} for continuous or \code{"I"} for integer. By default
    \code{NULL}, taken as all-continuous. Recycled as needed.}
  \item{max}{a logical giving the direction of the optimization.
    \code{TRUE} means that the objective is to maximize the objective
    function, \code{FALSE} (default) means to minimize it.}
  \item{control}{a list of parameters to the solver. Currently the
    only options are: \code{verbose}, a logical for turning on/off additional
    solver output; \code{canonicalize_status}, a logical indicating
    whether to canonicalize GLPK status codes or not. Defaults:
    \code{FALSE}; \code{TRUE}.}
  \item{mobj_i}{a vector of objective coefficient indices which will 
    get different values in each optimization problem. Defaults: \code{NULL}.}
  \item{mobj_val}{a matrix of objective coefficient values. Each 
    column specifies for one optimization problem the values of the objective 
    coefficients specified by in mobj_i.}
  \item{mmat_i}{a matrix of coordinates of \code{mat} matrix. Each row
    specifies one constraint cell (its row and column). The cell specified in row i
    will be assigned values from row i of matrix \code{mmat_val}. Cells not
    specified in \code{mat} will be left unchanged.
    Defaults: \code{NULL}.}
  \item{mmat_val}{a matrix of values, each column specifies values for one optimization 
    task. Cell specified in row i in \code{mmat_i} gets values from 
    row i of \code{mmat_val}.
    Defaults: \code{NULL}.}
  \item{mrhs_i}{a vector of RHS constraint rows that will get different values
    in each optimization problem.
    Defaults: \code{NULL}.}
  \item{mrhs_val}{a matrix of RHS values. Element \code{mrhs_val[i,j]} specifies
    RHS value for row \code{mrhs_i[i]} in optimization problem j.
    Defaults: \code{NULL}.}
  \item{\ldots}{a list of control parameters (overruling those specified in
          \code{control}).}
}
\details{
  Package \pkg{rDEA} provides method for Data Envelopment Analysis (DEA),
  including standard input, output and cost-minimization DEA estimation
  and also robust DEA solvers. The latter can be with or without
  additional environmental variables.
}
\value{
  A list containing the optimal solutions for each problem,
  with the following components.
  \item{solution}{the matrix of optimal coefficients, each column is one problem}
  \item{objval}{the vector of values of the objective function at the optimum, for each problem}
  \item{status}{the vector of integers with status information about the solution
    returned, for each problem. If the control parameter \code{canonicalize_status} is set
    (the default) then it will return 0 for the optimal solution being
    found, and non-zero otherwise. If the control parameter is set to
    \code{FALSE} it will return the GLPK status codes.}
}
\references{
  GNU Linear Programming Kit
  (\url{http://www.gnu.org/software/glpk/glpk.html}).
}
\author{Jaak Simm}
\seealso{
  \pkg{glpk} and \pkg{glpkAPI} for C API bindings;
  \code{\link[Rglpk]{Rglpk_solve}} in package \pkg{Rglpk}.
}
\examples{
## Simple linear program.
## maximize:   2 x_1 + 4 x_2 + 3 x_3
## subject to: 3 x_1 + 4 x_2 + 2 x_3 <= 60
##             2 x_1 +   x_2 + 2 x_3 <= 40
##               x_1 + 3 x_2 + 2 x_3 <= 80
##               x_1, x_2, x_3 are non-negative real numbers

obj <- c(2, 4, 3)
mat <- matrix(c(3, 2, 1, 4, 1, 3, 2, 2, 2), nrow = 3)
dir <- c("<=", "<=", "<=")
rhs <- c(60, 40, 80)
max <- TRUE

multi_glpk_solve_LP(obj, mat, dir, rhs, max = max)

## Simple mixed integer linear program.
## maximize:    3 x_1 + 1 x_2 + 3 x_3
## subject to: -1 x_1 + 2 x_2 +   x_3 <= 4
##                      4 x_2 - 3 x_3 <= 2
##                x_1 - 3 x_2 + 2 x_3 <= 3
##                x_1, x_3 are non-negative integers
##                x_2 is a non-negative real number

obj <- c(3, 1, 3)
mat <- matrix(c(-1, 0, 1, 2, 4, -3, 1, -3, 2), nrow = 3)
dir <- c("<=", "<=", "<=")
rhs <- c(4, 2, 3)
types <- c("I", "C", "I")
max <- TRUE

multi_glpk_solve_LP(obj, mat, dir, rhs, types = types, max = max)

## Same as before but with bounds replaced by
## -Inf <  x_1 <= 4
##    0 <= x_2 <= 100
##    2 <= x_3 <  Inf

bounds <- list(lower = list(ind = c(1L, 3L), val = c(-Inf, 2)),
               upper = list(ind = c(1L, 2L), val = c(4, 100)))
multi_glpk_solve_LP(obj, mat, dir, rhs, bounds, types, max)

## Examples from the GLPK manual
## Solver output enabled

## 1.3.1
## maximize:   10 x_1 + 6 x_2 + 4 x_3
## subject to:    x_1 +   x_2 +   x_3 <= 100
##             10 x_1 + 4 x_2 + 5 x_3 <= 600
##              2 x_1 + 2 x_2 + 6 x_3 <= 300
##                x_1,    x_2,    x_3 are non-negative real numbers

obj <- c(10, 6, 4)
mat <- matrix(c(1, 10, 2, 1, 4, 2, 1, 5, 6), nrow = 3)
dir <- c("<=", "<=", "<=")
rhs <- c(100, 600, 300)
max <- TRUE

multi_glpk_solve_LP(obj, mat, dir, rhs, max = max, control = list("verbose" =
TRUE, "canonicalize_status" = FALSE))

}
\keyword{optimize}
