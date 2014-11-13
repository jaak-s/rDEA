
data("dea_hospitals", package="rDEA")

H12 = subset(dea_hospitals, year == 12)
H12[is.na(H12)] = 0

## choosing inputs and outputs for analysis
X = H12[,c('x1', 'x2', 'x3', 'x5')]
Y = H12[,c('y1', 'y2')]
W = H12[,c('w1', 'w2', 'w3', 'w5')]
firms = 1:10

context("Input DEA")

test_that("input DEA with variable RTS works", {
  dea = dea( XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], model="input", RTS="variable" )
  expect_equal( length(dea$thetaOpt), length(firms) )
  correct_thetaOpt =  c(0.8318892, 0.4166437, 1.0000000, 0.9838584, 0.7870153, 0.8918320, 0.7517825, 0.6274347, 0.6044336, 0.4562620)
  expect_equal( dea$thetaOpt, correct_thetaOpt, tolerance=1e-5 )
  expect_equal( dea$lambda_sum, rep.int(1, length(firms)) )
})

test_that("input DEA with constant RTS works", {
  dea = dea( XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], model="input", RTS="constant" )
  expect_equal( length(dea$thetaOpt), length(firms) )
  correct_thetaOpt   = c(0.7984635, 0.4115119, 0.7819155, 0.8509834, 0.7589849, 0.8830402, 0.7391885, 0.6272689, 0.5663417, 0.4539587)
  correct_lambda_sum = c(1.7552852, 0.6940001, 4.2301076, 3.1562303, 1.4035927, 0.9229464, 1.0757771, 1.0615420, 0.5565966, 1.4986582)
  expect_equal( dea$thetaOpt, correct_thetaOpt, tolerance=1e-5 )
  expect_equal( dea$lambda_sum, correct_lambda_sum, tolerance=1e-5 )
})

test_that("input DEA with non-increasing RTS works", {
  dea = dea( XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], model="input", RTS="non-increasing" )
  expect_equal( length(dea$thetaOpt), length(firms) )
  correct_thetaOpt   = c(0.8318892, 0.4115119, 1.0000000, 0.9838584, 0.7870153, 0.8830402, 0.7517825, 0.6274347, 0.5663417, 0.4562620)
  correct_lambda_sum = c(1.0000000, 0.6940001, 1.0000000, 1.0000000, 1.0000000, 0.9229464, 1.0000000, 1.0000000, 0.5565966, 1.0000000)
  expect_equal( dea$thetaOpt, correct_thetaOpt, tolerance=1e-5 )
  expect_equal( dea$lambda_sum, correct_lambda_sum, tolerance=1e-5 )
})

##################################################################

context("Output DEA")

test_that("output DEA with variable RTS works", {
  dea = dea( XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], model="output", RTS="variable" )
  expect_equal( length(dea$thetaOpt), length(firms) )
  correct_thetaOpt = c(0.8566956, 0.4361563, 1.0000000, 0.9891156, 0.8286440, 0.8861781, 0.8187128, 0.6896913, 0.5670282, 0.5973477)
  expect_equal( dea$thetaOpt, correct_thetaOpt, tolerance=1e-5 )
  expect_equal( dea$lambda_sum, rep.int(1, length(firms)) )
})

test_that("output DEA with constant RTS works", {
  dea = dea( XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], model="output", RTS="constant" )
  expect_equal( length(dea$thetaOpt), length(firms) )
  correct_thetaOpt   = c(0.79846352180596, 0.41151186321040, 0.78191547262234, 0.8509833968360, 0.75898489453937, 0.88304017442415, 0.73918850524128, 0.62726889495695, 0.56634171983981, 0.453958669575282)
  correct_lambda_sum = c(2.19832863850184, 1.68646435238622, 5.40992955742233, 3.7089211795534, 1.84930261291768, 1.04519180267609, 1.45534877696086, 1.69232373208077, 0.982792779422565, 3.30130988353909)
  expect_equal( dea$thetaOpt, correct_thetaOpt, tolerance=1e-5 )
  expect_equal( dea$lambda_sum, correct_lambda_sum, tolerance=1e-5 )
})

test_that("output DEA with non-increasing RTS works", {
  dea = dea( XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], model="output", RTS="non-increasing" )
  expect_equal( length(dea$thetaOpt), length(firms) )
  correct_thetaOpt   = c(0.856695552478634, 0.436156271306031, 1, 0.989115625730642, 0.828644020200666, 0.886178140787594, 0.818712783530984, 0.689691319915979, 0.56634171983981, 0.597347713436698)
  correct_lambda_sum = c(1, 1, 1, 1, 1, 1, 1, 1, 0.982792779422565, 1)
  expect_equal( dea$thetaOpt, correct_thetaOpt, tolerance=1e-5 )
  expect_equal( dea$lambda_sum, correct_lambda_sum, tolerance=1e-5 )
})


##################################################################

context("Costmin DEA")

test_that("costmin DEA with variable RTS works", {
  dea = dea( XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], W=W[firms,], model="costmin", RTS="variable" )
  expect_equal( length(dea$gammaOpt), length(firms) )
  correct_gammaOpt = c(0.721704757187399, 0.375392168049305, 0.917664981395069, 0.918876231481052, 0.76653075695613, 0.859271996008044, 0.731855668245487, 0.612411985153844, 0.552216094552311, 0.38960407018854)
  correct_XOpt1 = c(7.34931598903593, 44.5179518848677, 18.0279496271356, 115.568236618212)
  correct_XOpt2 = c(3.78660783865678, 21.1744706520614, 13.9346267163477, 85.3274073300269)
  expect_equal( dea$gammaOpt, correct_gammaOpt, tolerance=1e-5 )
  expect_equal( dea$lambda_sum, rep.int(1, length(firms)) )
  expect_equal( dea$XOpt[1,], correct_XOpt1, tolerance=1e-5 )
  expect_equal( dea$XOpt[2,], correct_XOpt2, tolerance=1e-5 )
})

test_that("costmin DEA with constant RTS works", {
  dea = dea( XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], W=W[firms,], model="costmin", RTS="constant" )
  expect_equal( length(dea$gammaOpt), length(firms) )
  correct_gammaOpt = c(0.704688692315888, 0.37133012890203, 0.712930547459483, 0.712474143478145, 0.710422261138226, 0.856585018358924, 0.726133014763142, 0.605491151127793, 0.534736076414802, 0.29150574738414)
  correct_XOpt1 = c(5.5004261785087, 39.8306491434033, 25.7097483194497, 148.326589130894)
  correct_XOpt2 = c(3.84886621337591, 21.8723831972231, 12.7463743064303, 83.0588953728056)
  correct_lambda_sum = c(1.85402180270745, 0.786311797430082, 3.96050986309536, 3.99456612546613, 1.62884453911103, 1.05427916884122, 1.20398674643091, 1.37325261852835, 0.723959624673555, 8.77162267008427)
  expect_equal( dea$gammaOpt, correct_gammaOpt, tolerance=1e-5 )
  expect_equal( dea$lambda_sum, correct_lambda_sum, tolerance=1e-5 )
  expect_equal( dea$XOpt[1,], correct_XOpt1, tolerance=1e-5 )
  expect_equal( dea$XOpt[2,], correct_XOpt2, tolerance=1e-5 )
})

test_that("costmin DEA with non-increasing RTS works", {
  dea = dea( XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], W=W[firms,], model="costmin", RTS="non-increasing" )
  expect_equal( length(dea$gammaOpt), length(firms) )
  correct_gammaOpt = c(0.721704757187399, 0.37133012890203, 0.917664981395069, 0.918876231481052, 0.76653075695613, 0.859271996008044, 0.731855668245487, 0.612411985153844, 0.534736076414802, 0.38960407018854)
  correct_XOpt1 = c(7.34931598903593, 44.5179518848677, 18.0279496271356, 115.568236618212)
  correct_XOpt2 = c(3.84886621337591, 21.8723831972231, 12.7463743064303, 83.0588953728056)
  correct_lambda_sum = c(1, 0.786311797430082, 1, 1, 1, 1, 1, 1, 0.723959624673555, 1)
  expect_equal( dea$gammaOpt, correct_gammaOpt, tolerance=1e-5 )
  expect_equal( dea$lambda_sum, correct_lambda_sum, tolerance=1e-5 )
  expect_equal( dea$XOpt[1,], correct_XOpt1, tolerance=1e-5 )
  expect_equal( dea$XOpt[2,], correct_XOpt2, tolerance=1e-5 )
})
