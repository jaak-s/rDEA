\name{Rglpk_read_file}
\alias{Rglpk_read_file}
\alias{print.MP_data_from_file}
\title{Interface to GLPK's file reader}
\description{
  High level R interface to the CPLEX\_LP, MATHPROG and MPS reader of the GNU Linear
  Programming Kit (GLPK). Example data from the GLPK release is included
  in the \code{'./examples/'} sub-directory.
}
\usage{
## File reader for various formats
Rglpk_read_file(file, type = c("MPS_fixed", "MPS_free", "CPLEX_LP", "MathProg"),
ignore_first_row = FALSE, verbose = FALSE) 

## print method
\method{print}{MP_data_from_file}(x, \ldots)
}
\arguments{
  \item{file}{a character string specifying the relative or absolute path to
    the model file.}
  \item{type}{a character string specifying the file format. This can be either
    \code{"MPS_fixed"}, \code{"MPS_free"}, \code{"CPLEX_LP"}, and
    GNU \code{"MathProg"}.}
  \item{ignore_first_row}{a logical indicating whether the first row of
    the model file should be ignored or not.
    Default: \code{FALSE}.}
  \item{verbose}{a logical for turning on/off additional solver output.
    Default: \code{FALSE}.}
  \item{x}{an object of class \code{"MP_data_from_file"}.}
  \item{\ldots}{further arguments passed on to the print method.}
}
\details{\code{Rglpk_read_file()} takes the path to a file as an
  argument and calls GLPK's file reader. The description of the linear or
  mixed integer linear program is returned as an object of class
  \code{"MP_data_from_file"}.
}
\value{
  \code{Rglpk_read_file()} returns the specification of a (mixed integer)
  linear program defined in \code{file} as an object of class
  \code{"MP_data_from_file"}. The returned object is a list containing
  the following components.
  
  \item{objective}{a \code{"\link[slam]{simple_triplet_matrix}"} representing the coefficients to \eqn{x} in the objective function.}
  \item{constraints}{a list with three elements: a
  \code{"\link[slam]{simple_triplet_matrix}"} of coefficients, a character
  vector of constraint directions, and a numeric vector representing the
  right hand side.}
  \item{bounds}{a list containing two elements: \code{lower} and
  \code{upper}. Each of which contain a list specifying indices
  (\code{ind}) and corresponding bounds (\code{val}).}
  \item{types}{a character vector specifying whether the corresponding
  objective variable is of type binary (\code{"B"}), continuous
  (\code{"C"}), or integer (\code{"I"}).} 
  \item{maximum}{a logical indicating whether a minimum or a maximum is sought.}

  Further meta data is provided as attributes to the object.
}
%%\references{}
\author{Stefan Theussl}
%%\seealso{}
\examples{
## read a CPLEX LP file
x <- Rglpk_read_file( system.file(file.path("examples", "plan.lp"), package
= "Rglpk"), type = "CPLEX_LP")
x
## optimal solution: 296.2166
Rglpk_solve_LP(x$objective, x$constraints[[1]], x$constraints[[2]],
                x$constraints[[3]], x$bounds, x$types, x$maximum)
## read a MATHPROG file
x <- Rglpk_read_file( system.file(file.path("examples", "assign.mod"), package
= "Rglpk"), type = "MathProg")
x
## optimal solution: 76
Rglpk_solve_LP(x$objective, x$constraints[[1]], x$constraints[[2]],
                x$constraints[[3]], x$bounds, x$types, x$maximum)
## read a MATHPROG file
x <- Rglpk_read_file( system.file(file.path("examples", "plan.mps"), package
= "Rglpk"), type = "MPS_fixed")
x
## optimal solution: 296.2166
Rglpk_solve_LP(x$objective, x$constraints[[1]], x$constraints[[2]],
                x$constraints[[3]], x$bounds, x$types, x$maximum)
}
\keyword{IO}
\keyword{utilities}
