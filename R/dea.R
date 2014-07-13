
######## input minimization with rescaling ######
dea.input.rescaling <- function(XREF, YREF, X, Y, RTS, rescaling=1) {
  XREF.rescaled = XREF * rescaling
  result = dea.input(XREF=XREF.rescaled, YREF=YREF, X=X, Y=Y, RTS=RTS)
  return(result$thetaOpt)
}

dea.output.rescaling <- function(XREF, YREF, X, Y, RTS, rescaling=1) {
  YREF.rescaled = YREF / rescaling
  result = dea.output(XREF=XREF, YREF=YREF.rescaled, X=X, Y=Y, RTS=RTS)
  return(result$thetaOpt)
}


dea <- function(XREF, YREF, X, Y, W=NULL, model, RTS="variable") {
  if (missing(model) || ! model %in% c("input", "output", "costmin") ) {
    stop("Parameter model has to be either 'input', 'output' or 'costmin'.")
  }
  if (model == "input") {
    return( dea.input(XREF=XREF, YREF=YREF, X=X, Y=Y, RTS) )
  } else if (model == "output") {
    return( dea.output(XREF=XREF, YREF=YREF, X=X, Y=Y, RTS) )
  } else {
    stop("unimplemented")
  }
  
}

######## cost minimization with LP using GLPK ########
### XREF - N x Dinput matrix for ref. inputs (possibly multiplied by prices), N is the number of firms
### YREF - N x Doutput matrix for ref. outputs
### X - M x Dinput matrix of inputs (only for calculating cost efficiency)
### Y - M x Doutput matrix of outputs
### RTS - returns to scale: "variable" (default), "constant", "non-increasing"
######## output #######
### out$thetaOpt = thetaOpt
### out$lambda   = lambda
### out$feasible = feasible
### out$lambda_sum = rowSums(lambda)
dea.input <- function(XREF, YREF, X, Y, RTS="variable") {
  if ( ! is.matrix(XREF)) { XREF = as.matrix(XREF) }
  if ( ! is.matrix(YREF)) { YREF = as.matrix(YREF) }
  if ( ! is.matrix(X)) { X = as.matrix(X) }
  if ( ! is.matrix(Y)) { Y = as.matrix(Y) }

  if ( ! is.numeric(XREF)) { stop("XREF has to be numeric matrix or data.frame.") }
  if ( ! is.numeric(YREF)) { stop("YREF has to be numeric matrix or data.frame.") }
  if ( ! is.numeric(X)) { stop("X has to be numeric matrix or data.frame.") }
  if ( ! is.numeric(Y)) { stop("Y has to be numeric matrix or data.frame.") }
  
  if (nrow(XREF) != nrow(YREF)) { stop( sprintf("Number of rows in XREF (%d) does not equal the number of rows in YREF (%d)", nrow(XREF), nrow(YREF)) ) }
  if (nrow(X) != nrow(Y)) { stop( sprintf("Number of rows in X (%d) does not equal the number of rows in Y (%d)", nrow(X), nrow(Y)) ) }
  
  ## N is the number of firms in reference
  N = nrow(XREF)
  ## M is the number of firms for which we calculate the efficiency
  M = nrow(X)
  Dinput  = ncol(XREF)
  Doutput = ncol(YREF)
  
  # variables = c(lambdas(N), theta(1) )
  
  # objective function:
  obj = c(rep(0, N), 1)
  
  # constraints in GLPK by default set variables to [0, Inf), see bounds in GLPK
  # constraint matrix C, RHS, constraint type:
  # we have a constriant for each output and for each input.
  C  = matrix(0.0, Doutput+Dinput, N+1 )
  b  = rep(0.0,    Doutput+Dinput)
  cd = rep(">=",   Doutput+Dinput)
  
  # constraints on outputs:
  C[1:Doutput, 1:N] = t(YREF)
  # b[1:Doutput] will be changed for each firm in the for loop
  
  # constraints on inputs: -X'*lambda + theta*x0 >= 0
  C[(Doutput+1):(Doutput+Dinput), 1:N ]  = -t(XREF)  ## -X' * lambda
  #C[(Doutput+1):(Doutput+Dinput), (N+1)] will be changed for each firm in the loop
  
  # positivity constrant on lambdas (unnecessary, they are bounded below from 0 in GLPK):
  
  # variable returns to scale constraint:
  if (RTS=="variable") {
    ## adding constraint sum(lambda) == 1
    C  = rbind(C, c(rep(1.0,N), 0.0) )
    b  = c(b, 1.0)
    cd = c(cd, "==")
  } else if (RTS=="non-increasing") {
    ## adding constraint sum(lambda) < 1
    C  = rbind(C, c(rep(1.0,N), 0.0) )
    b  = c(b, 1.0)
    cd = c(cd, "<")
  } else {
    ## constant returns to scale, no constraint needed.
  }
  
  ## using multi optimization to solve M linear programs
  outlp = multi_glpk_solve_LP(obj=obj, mat=C, dir=cd, rhs=b,
                              mrhs_i   = 1:Doutput,
                              mrhs_val = t(Y),
                              mmat_i   = cbind( (Doutput+1):(Doutput+Dinput), N+1 ),
                              mmat_val = t(X))

  feasible = matrix(outlp$status==0)
  thetaOpt = matrix(outlp$solution[N+1,])
  lambda   = t(outlp$solution[1:N, ])

  # output:
  out = list()
  out$thetaOpt = thetaOpt
  out$lambda   = lambda
  out$feasible = feasible
  # necessary for VRS case, all rows should be equal to 1:
  out$lambda_sum = rowSums(lambda)
  
  return(out)
}


######## output DEA with LP using Rglpk ########
### XREF - N x Dinput matrix for ref. inputs (possibly multiplied by prices), N is the number of firms
### YREF - N x Doutput matrix for ref. outputs
### X - M x Dinput matrix of inputs (only for calculating cost efficiency)
### Y - M x Doutput matrix of outputs
### RTS - returns to scale: "variable" (default), "constant", "non-increasing"
######## output #######
### out$thetaOpt = thetaOpt
### out$lambda   = lambda
### out$feasible = feasible
### out$lambda_sum = rowSums(lambda)
dea.output <- function(XREF, YREF, X, Y, RTS="variable") {
  if ( ! is.matrix(XREF)) { XREF = as.matrix(XREF) }
  if ( ! is.matrix(YREF)) { YREF = as.matrix(YREF) }
  if ( ! is.matrix(X)) { X = as.matrix(X) }
  if ( ! is.matrix(Y)) { Y = as.matrix(Y) }
  
  if ( ! is.numeric(XREF)) { stop("XREF has to be numeric matrix or data.frame.") }
  if ( ! is.numeric(YREF)) { stop("YREF has to be numeric matrix or data.frame.") }
  if ( ! is.numeric(X)) { stop("X has to be numeric matrix or data.frame.") }
  if ( ! is.numeric(Y)) { stop("Y has to be numeric matrix or data.frame.") }
  
  if (nrow(XREF) != nrow(YREF)) { stop( sprintf("Number of rows in XREF (%d) does not equal the number of rows in YREF (%d)", nrow(XREF), nrow(YREF)) ) }
  if (nrow(X) != nrow(Y)) { stop( sprintf("Number of rows in X (%d) does not equal the number of rows in Y (%d)", nrow(X), nrow(Y)) ) }
  
  ## N is the number of firms in reference
  N = nrow(XREF)
  ## M is the number of firms for which we calculate the efficiency
  M = nrow(X)
  Dinput  = ncol(XREF)
  Doutput = ncol(YREF)
  
  # variables = c(lambdas(N), theta(1) )
  
  # objective function:
  obj = c(rep(0, N), 1)
  
  # constraints in Rglpk by default set variables to [0, Inf), see bounds in Rglpk
  # constraint matrix C, RHS, constraint type:
  # we have a constriant for each output and for each input.
  C  = matrix(0.0, Doutput+Dinput, N+1 )
  b  = rep(0.0,    Doutput+Dinput)
  cd = rep(">=",   Doutput+Dinput)
  
  # constraints on outputs: Y'*lambda - theta*y >= 0
  C[1:Doutput, 1:N] = t(YREF)
  #C[1:Doutput, (N+1)] will be changed for each firm in the loop
  
  # constraints on inputs: -X'*lambda >= -x0
  C[(Doutput+1):(Doutput+Dinput), 1:N ]  = -t(XREF)  ## -X' * lambda
  # b[(Doutput+1):(Doutput+Dinput)] will be changed for each firm in the for loop
  
  # positivity constrant on lambdas (unnecessary, they are bounded below from 0 in Rglpk):
  
  # variable returns to scale constraint:
  if (RTS=="variable") {
    ## adding constraint sum(lambda) == 1
    C  = rbind(C, c(rep(1.0,N), 0.0) )
    b  = c(b, 1.0)
    cd = c(cd, "==")
  } else if (RTS=="non-increasing") {
    ## adding constraint sum(lambda) < 1
    C  = rbind(C, c(rep(1.0,N), 0.0) )
    b  = c(b, 1.0)
    cd = c(cd, "<")
  } else {
    ## constant returns to scale, no constraint needed.
  }
  
  # output matrix for Xopt
  thetaOpt = matrix(0.0, M, 1)
  lambda   = matrix(0.0, M, N)
  feasible = matrix(TRUE, M, 1)
  for (m in 1:M) {
    # firm specific outputs:
    C[1:Doutput, N+1] = -Y[m,]
    # firm specific inputs:
    b[(Doutput+1):(Doutput+Dinput)] = -X[m,]
    
    outlp=multi_glpk_solve_LP(obj=obj, mat=C, dir=cd, rhs=b, max=TRUE)
    
    feasible[m,1] = (outlp$status==0)
    
    # taking optimal theta (we get delta and take its reciprocal)
    thetaOpt[m,] = 1 / outlp$solution[N+1]
    # lambda from the LP solution:
    lambda[m,]   = outlp$solution[1:N]
  }
  
  # output:
  out = list()
  out$thetaOpt = thetaOpt
  out$lambda   = lambda
  out$feasible = feasible
  # necessary for VRS case, all rows should be equal to 1:
  out$lambda_sum = rowSums(lambda)
  
  return(out)
}
