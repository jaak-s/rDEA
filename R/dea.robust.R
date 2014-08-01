### Bias-corrected DEA, input oriented case, (Simar and Wilson, 1998) 

###### [ Inputs to the method ] ######
### X[firm, input_feat]  - inputs
### Y[firm, output_feat] - outputs
### W[firm, input_feat]  - input prices, only needed for cost minimization
### RTS   - returns to scale, "variable" (default), "constant" and "non-increasing"
### B     - number of bootstraps (replications), default is 1000
### alpha - confidence level, default is 0.05

###### [ Outputs from the method ] ######
### out$theta_hat      - original DEA efficiency score
### out$theta_hat_star - efficiency scores for bootstrapped data
### out$bias           - bias
### out$theta_hat_hat  - bias corrected efficiency scores 
dea.robust <- function(X, Y, W=NULL, model, RTS="variable", B=1000, alpha=0.05,
                       bw = "bw.ucv") {
  if (missing(model) || ! model %in% c("input", "output", "costmin") ) {
    stop("Parameter 'model' has to be either 'input', 'output' or 'costmin'.")
  }
  if ( ! is.matrix(X)) { X = as.matrix(X) }
  if ( ! is.matrix(Y)) { Y = as.matrix(Y) }
  if ( ! is.numeric(X)) { stop("X has to be numeric matrix or data.frame.") }
  if ( ! is.numeric(Y)) { stop("Y has to be numeric matrix or data.frame.") }
  if ( any(is.na(X)) ) stop("X contains NA. Missing values are not supported.")
  if ( any(is.na(Y)) ) stop("Y contains NA. Missing values are not supported.")
  
  if (nrow(X) != nrow(Y)) { stop( sprintf("Number of rows in X (%d) does not equal the number of rows in Y (%d)", nrow(X), nrow(Y)) ) }
  
  if (model == "input") {
    return( bias.correction.sw98(X=X, Y=Y, RTS=RTS, B=B, alpha=alpha, bw=bw,
                                 deaMethod=dea.input.rescaling) )
  } else if (model == "output") {
    return( bias.correction.sw98(X=X, Y=Y, RTS=RTS, B=B, alpha=alpha, bw=bw,
                                 deaMethod=dea.output.rescaling) )
  } else { 
    return( dea.robust.costmin(X=X, Y=Y, W=W, RTS=RTS, B=B, alpha=alpha, bw=bw) )
  }
}

### inputs:
### bw - theta bandwidth calculation method, either user supplied function or
###      1) "silverman", "bw.nrd0" for Silverman rule
###      2) "rule" for rule of thumb
###      3) "cv", "bw.ucv" for unbiased cross-validation
bias.correction.sw98 <- function(X, Y, RTS, B, alpha, deaMethod, bw) {
  if (!is.matrix(X)) X = as.matrix(X)
  if (!is.matrix(Y)) Y = as.matrix(Y)
  out = list()

  # number of firms
  N    = nrow( as.matrix(X) )
  Ydim = ncol( as.matrix(Y) )
  Xdim = ncol( as.matrix(X) )
    
  # (1) calculating original theta_hat in DEA:
  theta_hat      = deaMethod(XREF=X, YREF=Y, X=X, Y=Y, RTS=RTS)
  var_theta_hat  = var(theta_hat)
  mean_theta_hat = mean(theta_hat)
  out$theta_hat  = theta_hat
  
  # finding the bandwidth for kernel sampling:
  if (is.function(bw)) {
    bw_value = bw( as.vector(theta_hat) )
  } else if (bw == "rule") {
    bw_value = bandwidth_rule( ncol(X), ncol(Y), nrow(X) )
  } else if (bw %in% c("silverman", "bw.nrd0") ) {
    bw_value = bw.nrd0( as.vector(theta_hat) )
  } else if (bw %in% c("cv", "bw.ucv")) {
    suppressWarnings({
      bw_value = bw.ucv( as.vector(theta_hat) )
    })
  } else {
    stop( sprintf("Illegal bandwidth type '%s'.", bw) )
  }
  
  # bootstrap loop (order of the loops is like in SW98 paper):
  theta_hat_star = matrix(0, N, B)
  for (b in 1:B) {
    # (2) reflection method, sampling reciprocals of distance from smooth kernel function:
    # use sampling from log normal to avoid negative values
    theta_hat_boot = sampling_with_reflection( N, theta_hat, bw_value, var_theta_hat, mean_theta_hat )
    # (3) new output based on the efficiencies:
    rescaleFactor = as.vector(theta_hat / theta_hat_boot)
    
    # (4) DEA efficiencies for scores:
    # The efficiency of the original data under the bootstrapped technology:
    theta_hat_star[,b] = deaMethod(XREF=X, YREF=Y, X=X, Y=Y, RTS=RTS, 
                                   rescaling=rescaleFactor)
  }
  out$theta_hat_star = theta_hat_star
  
  # (5) bias
  bias = rowMeans(theta_hat_star) - theta_hat
  # (6) bias-corrected estimator
  theta_hat_hat = theta_hat - bias

  out$bias          = bias
  out$theta_hat_hat = theta_hat_hat

  # calculating confidence interval for theta:
  theta_ci = apply( theta_hat_star, 1, quantile, c(alpha/2, 1-alpha/2) )
  out$theta_ci_low  = theta_ci[1,] - 2*bias
  out$theta_ci_high = theta_ci[2,] - 2*bias

  return(out)
}


### Inputs to the method ###
### Robust costmin for Fare's definition (Besstremyannaya et al, in press)
### X[firm, xfeat] - production inputs in units
### W[firm, xfeat] - prices of inputs for each firm
### Y[firm, yfeat] - production outputs
### RTS       - returns to scale: "variable" (default), "non-increasing", "constant"
### B         - number of bootstraps
### alpha     - confidence interval, i.e., 0.05
### bw        - "cv", "silverman", "rule"
dea.robust.costmin <- function(X, Y, W, RTS, B, alpha, bw) {
  if (!is.matrix(X)) X = as.matrix(X)
  if (!is.matrix(Y)) Y = as.matrix(Y)
  if (!is.matrix(W)) W = as.matrix(W)
  if ( any(is.na(X)) ) stop("X contains NA. Missing values are not supported.")
  if ( any(is.na(Y)) ) stop("Y contains NA. Missing values are not supported.")
  if ( any(is.na(W)) ) stop("W contains NA. Missing values are not supported.")
  
  out = list()
  
  # number of firms
  N    = nrow( as.matrix(X) )
  Ydim = ncol( as.matrix(Y) )
  Xdim = ncol( as.matrix(X) )
  
  # (1) calculating original theta_hat in DEA:
  theta_hat     = dea.input.rescaling(XREF=X, YREF=Y, X=X, Y=Y, RTS=RTS, rescaling=1)
  gamma_hat     = dea.costmin.rescaling(XREF=X, YREF=Y, W=W, X=X, Y=Y, RTS=RTS, rescaling=1)
  out$theta_hat = theta_hat
  out$gamma_hat = gamma_hat
  var_theta_hat  = var(theta_hat)
  mean_theta_hat = mean(theta_hat)
  # finding the bandwidth for kernel sampling:
  if (is.function(bw)) {
    bw_value = bw( as.vector(theta_hat) )
  } else if (bw == "rule") {
    bw_value = bandwidth_rule( ncol(X), ncol(Y), nrow(X) )
  } else if (bw %in% c("silverman", "bw.nrd0") ) {
    bw_value = bw.nrd0( as.vector(theta_hat) )
  } else if (bw %in% c("cv", "bw.ucv")) {
    suppressWarnings({
      bw_value = bw.ucv( as.vector(theta_hat) )
    })
  } else {
    stop( sprintf("Illegal bandwidth type '%s'.", bw) )
  }
  
  out$bw = bw_value
  # bootstrap loop (order of the loops is like in SW98 paper):
  gamma_hat_star = matrix(0, N, B)
  #w_hat_boot     = matrix(0, B, 1)
  for (b in 1:B) {
    # (2) reflection method, sampling reciprocals of distance from smooth kernel function:
    theta_hat_boot = sampling_with_reflection( N, theta_hat, bw_value, var_theta_hat, mean_theta_hat )
    # (3) new output based on the efficiencies:
    rescaleFactor = as.vector(theta_hat / theta_hat_boot)
    
    # (4) DEA efficiencies for scores:
    # The efficiency of the original data under the bootstrapped technology:
    gamma_hat_star[,b] = dea.costmin.rescaling(XREF=X, YREF=Y, W=W, X=X, Y=Y, RTS=RTS, 
                                               rescaling=rescaleFactor)
  }
  out$gamma_hat_star = gamma_hat_star
  
  # (5) bias
  bias = rowMeans(gamma_hat_star) - gamma_hat
  # (6) bias-corrected estimator 
  gamma_hat_hat = gamma_hat - bias
  
  out$bias          = bias
  out$gamma_hat_hat = gamma_hat_hat
  
  # calculating confidence interval for theta:
  gamma_ci = apply( gamma_hat_star, 1, quantile, c(alpha/2, 1-alpha/2) )
  out$gamma_ci_low  = gamma_ci[1,] - 2*bias
  out$gamma_ci_high = gamma_ci[2,] - 2*bias
  
  ## from Kneip et al (2008), page 1676-1677:
  out$ratio_ci_low  = gamma_ci[1,] / out$gamma_hat - 1
  out$ratio_ci_high = gamma_ci[2,] / out$gamma_hat - 1
  
  ## paper approach
  #out$ratio2_ci = apply( gamma_hat_star / out$gamma_hat - 1, 1, quantile, c(alpha/2, 1-alpha/2) )
  
  ## ratio ci low is used for gamma ci high
  out$gamma_ci_kneip_high = out$gamma_hat / (1 + out$ratio_ci_low) #sw98.fare
  out$gamma_ci_kneip_low  = out$gamma_hat / (1 + out$ratio_ci_high)
  
  return(out)
}