# loading functions for input-oriented DEA

### RTS test statistic (4.6) in Simar and Wilson (2002)
RTSStatistic46 <- function(dist_crs, dist_vrs) {
  return( sum(dist_crs) / sum(dist_vrs) )
}

### RTS test statistic (4.5) in Simar and Wilson (2002)
RTSStatistic45 <- function(dist_crs, dist_vrs) {
  return( mean(dist_crs/dist_vrs) )
}

### RTS statistic (48) in Simar and Wilson (2011) J Prod Anal p.47
RTSStatistic48 <- function(dist_crs, dist_vrs) {
  return( mean(dist_crs/dist_vrs)-1 )
}

fixaround1 <- function(x) {
  x[ 1 - 1e-5 < x & x < 1 + 1e-5] <- 1
  x
}


######## Return to Scale Test (Simar and Wilson, 2002) ########

###### [ Inputs to the method ] ######
### X[firm, xfeat] - production inputs
### Y[firm, yfeat] - production output
### W[firm, xfeat] - input prices,  only necessary when model="costmin"
### model - either "input" (default), "output" or "costmin"
### H0    - which RTS test to perform: "constant" vs variable (default), "non-increasing" vs variable.
### bw - theta bandwidth calculation method.
###      Either user supplied function or:
###      1) "silverman", "bw.nrd0" for Silverman rule
###      2) "rule" for rule of thumb
###      3) "cv", "bw.ucv" for unbiased cross-validation
###      Default is CV. 
### B     - number of bootstraps, default 2000
### alpha - confidence level, i.e., 0.05 (default)

###### [ Outputs from the method ] ######
### out$D_crs_hat  - theta, estimated reciprocal of DEA distance under CRS
### out$D_vrs_hat  - theta, estimated reciprocal of DEA distance under VRS
### out$w_hat      - estimated test statistic (4.6)
### out$w45_hat    - estimated test statistic (4.5), not used in the function, just calculated
### out$w_hat_boot - bootstrapped values for test statistic (4.6)
### out$w45_hat_boot - bootstrapped values for test statistic (4.5)
### out$pvalue     - p-value (from bootstrap)
### out$H0level    - test statistic value at alpha significance for data being CRS
### out$H0reject   - TRUE if H0 is rejected, i.e., pvalue < alpha
rts.test <- function(X, Y, W=NULL, model, H0="constant", bw="cv", B=2000, alpha=0.05) {
  out = list()
  if (! is.matrix(X)) X = as.matrix(X)
  if (! is.matrix(Y)) Y = as.matrix(Y)
  if (! is.numeric(X)) stop("X has to be numeric.")
  if (! is.numeric(Y)) stop("Y has to be numeric.")
  if ( any(is.na(X)) ) stop("X contains NA. Missing values are not supported.")
  if ( any(is.na(Y)) ) stop("Y contains NA. Missing values are not supported.")
  
  if (model == "costmin") {
    if ( is.null(W) )    stop("For costmin input prices (W) are necessary.")
    if (! is.matrix(W)) W = as.matrix(W)
    if (! is.numeric(W)) stop("W has to be numeric.")
    if ( any(is.na(W)) ) stop("W contains NA. Missing values are not supported.")
  }
  
  if (missing(model) || ! model %in% c("input", "output", "costmin") ) {
    stop("model has to be either 'input', 'output' or 'costmin'.")
  }
  
  if (! H0 %in% c("constant", "non-increasing")) {
    stop("H0 has to be either 'constant' or 'non-increasing'.")
  }
  
  if (! bw %in% c("cv", "silverman")) {
    stop("bw has to be either 'cv' (cross-validation) or 'silverman'.")
  }
  
  N    = nrow( X )
  Ydim = ncol( Y )
  
  if (model == "input")   dea = dea.input.rescaling
  if (model == "output")  dea = dea.output.rescaling
  if (model == "costmin") dea = function(...) dea.costmin.rescaling(W=W, ...)

  # (1) calculating input-oriented DEA with CRS and VRS:
  D_crs_hat = fixaround1( as.vector( dea(XREF=X, YREF=Y, X=X, Y=Y, RTS=H0) ) )
  D_vrs_hat = fixaround1( as.vector( dea(XREF=X, YREF=Y, X=X, Y=Y, RTS="variable") ) )
  w_hat     = RTSStatistic46( D_crs_hat, D_vrs_hat )
  
  out$w_hat   = w_hat
  #out$w45_hat = RTSStatistic45( D_crs_hat, D_vrs_hat )
  out$w48_hat = RTSStatistic48( D_crs_hat, D_vrs_hat )
  out$D_crs_hat = D_crs_hat
  out$D_vrs_hat = D_vrs_hat

  # finding the bandwidth for kernel sampling:
  if (is.function(bw)) {
    ## user-supplied function
    bw_value = bw( as.vector(D_crs_hat) )
  } else if (bw %in% c("silverman", "bw.nrd0") ) {
    ## silverman (using iqr)
    bw_value = bw.nrd0( as.vector(D_crs_hat) )
  } else if (bw %in% c("cv", "bw.ucv")) {
    ## unbiased cross-validated bw
    suppressWarnings({
      bw_value = bw.ucv( as.vector(D_crs_hat) )
    })
  } else {
    stop( sprintf("Illegal bandwidth type '%s'.", bw) )
  }
  
  var_D_crs_hat = var(D_crs_hat)
  mean_D_crs_hat = mean(D_crs_hat)
  
  # bootstrap loop:
  w_hat_boot = matrix(0, B, 1)
  w45_hat_boot = matrix(0, B, 1)
  w48_hat_boot = matrix(0, B, 1)
  for (i in 1:B) {
    # (2) reflection method, sampling reciprocals of distance from smooth kernel function:
    D_crs_boot = sampling_with_reflection( N, D_crs_hat, bw_value, var_D_crs_hat, mean_D_crs_hat )
    # (3) new output based on the efficiencies:
    #X_boot     = X * (D_crs_hat / D_crs_boot)
    rescaling = (D_crs_hat / D_crs_boot)
    # (4) DEA efficiencies for scores:
    D_crs_hat_boot  = dea(XREF=X, YREF=Y, X=X, Y=Y, rescaling=rescaling, RTS=H0)
    D_vrs_hat_boot  = dea(XREF=X, YREF=Y, X=X, Y=Y, rescaling=rescaling, RTS="variable")
    w_hat_boot[i]   = RTSStatistic46( D_crs_hat_boot, D_vrs_hat_boot )
    w45_hat_boot[i] = RTSStatistic45( D_crs_hat_boot, D_vrs_hat_boot )
    w48_hat_boot[i] = RTSStatistic48( D_crs_hat_boot, D_vrs_hat_boot )
    #if (w_hat_boot[i] == 0) {
    #  ## TODO remove this if
    #  out$debug_d_crs_hat_boot = D_crs_hat_boot
    #  out$debug_d_vrs_hat_boot = D_vrs_hat_boot
    #  out$debug_d_crs_boot     = D_crs_boot
    #  out$debug_rescaling = rescaling
    #}
  }
  out$w_hat_boot   = w_hat_boot
  #out$w45_hat_boot = w45_hat_boot
  out$w48_hat_boot = w48_hat_boot
  
  # number of bootstrapped statistic values smaller than w_hat:
  w_hat_ind = sum(w_hat_boot < w_hat)
  # p-value, +1 is added to avoid 0 p-value (minimum value is 1/B)
  out$pvalue   = (w_hat_ind + 1) / B
  #out$pvalue45 = (sum(w45_hat_boot < out$w45_hat) + 1) / B
  out$pvalue48 = (sum(w48_hat_boot < out$w48_hat) + 1) / B # need to check, Simar and Wilson (2011) p.47
  # reject H0 (i.e., data is CRS) when alpha is bigger than p-value
  out$H0reject   = out$pvalue < alpha
  #out$H0reject45 = out$pvalue45 < alpha
  out$H0reject48 = out$pvalue48 < alpha
  # sorting and finding out the cut off statistic value for conficence alpha:
  out$H0level   = sort(w_hat_boot)[   floor(alpha*B) ]
  #out$H0level45 = sort(w45_hat_boot)[ floor(alpha*B) ]
  out$H0level48 = sort(w48_hat_boot)[ floor(alpha*B) ]
  # store H0:
  out$H0       = H0
  # bw:
  out$bw       = bw
  out$bw_value = bw_value
  
  return(out)
}
