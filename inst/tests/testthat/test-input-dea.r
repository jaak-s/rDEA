
context("Input DEA")

data("dea_hospitals")

H12 = subset(dea_hospitals, year == 12)
H12[is.na(H12)] = 0

## choosing inputs and outputs for analysis
X = H12[,c('x1','x2','x3','x5')]
Y = H12[,c('y1','y2')]
firms = 1:10

test_that("input DEA with variable RTS works", {
  dea = input.dea( XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], RTS="variable" )
  expect_equal( length(dea$thetaOpt), length(firms) )
  correct_thetaOpt =  c(0.8318892, 0.4166437, 1.0000000, 0.9838584, 0.7870153, 0.8918320, 0.7517825, 0.6274347, 0.6044336, 0.4562620)
  expect_equal( dea$thetaOpt, matrix(correct_thetaOpt), tolerance=1e-5 )
  expect_equal( dea$lambda_sum, rep.int(1, length(firms)) )
})

test_that("input DEA with constant RTS works", {
  dea = input.dea( XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], RTS="constant" )
  expect_equal( length(dea$thetaOpt), length(firms) )
  correct_thetaOpt   = c(0.7984635, 0.4115119, 0.7819155, 0.8509834, 0.7589849, 0.8830402, 0.7391885, 0.6272689, 0.5663417, 0.4539587)
  correct_lambda_sum = c(1.7552852, 0.6940001, 4.2301076, 3.1562303, 1.4035927, 0.9229464, 1.0757771, 1.0615420, 0.5565966, 1.4986582)
  expect_equal( dea$thetaOpt, matrix(correct_thetaOpt), tolerance=1e-5 )
  expect_equal( dea$lambda_sum, correct_lambda_sum, tolerance=1e-5 )
})

test_that("input DEA with non-increasing RTS works", {
  dea = input.dea( XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], RTS="non-increasing" )
  expect_equal( length(dea$thetaOpt), length(firms) )
  correct_thetaOpt   = c(0.8318892, 0.4115119, 1.0000000, 0.9838584, 0.7870153, 0.8830402, 0.7517825, 0.6274347, 0.5663417, 0.4562620)
  correct_lambda_sum = c(1.0000000, 0.6940001, 1.0000000, 1.0000000, 1.0000000, 0.9229464, 1.0000000, 1.0000000, 0.5565966, 1.0000000)
  expect_equal( dea$thetaOpt, matrix(correct_thetaOpt), tolerance=1e-5 )
  expect_equal( dea$lambda_sum, correct_lambda_sum, tolerance=1e-5 )
})
