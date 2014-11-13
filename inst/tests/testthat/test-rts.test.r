
data("dea_hospitals", package="rDEA")

H12 = subset(dea_hospitals, year == 12)
H12[is.na(H12)] = 0

## choosing inputs and outputs for analysis
firms = 1:40
X = H12[firms, c('x1', 'x2', 'x3', 'x5')]
Y = H12[firms, c('y1', 'y2')]
W = H12[firms, c('w1', 'w2', 'w3', 'w5')]

B = 20

context("Input rts.test")

test_that("input rts.test with H0='constant'", {
  r = rts.test(X=X, Y=Y, model="input", H0="constant", B = B)
  expect_equal( length(r$theta_crs_hat), length(firms) )
  expect_equal( length(r$theta_vrs_hat), length(firms) )
  expect_equal( length(r$w_hat_boot),   B )
  expect_equal( length(r$w48_hat_boot), B )
  
  expect_true( all(r$theta_crs_hat <= 1) )
  expect_true( all(r$theta_vrs_hat <= 1) )
})

test_that("input rts.test with H0='non-increasing'", {
  r = rts.test(X=X, Y=Y, model="input", H0="non-increasing", B = B)
  expect_equal( length(r$theta_crs_hat), length(firms) )
  expect_equal( length(r$theta_vrs_hat), length(firms) )
  expect_equal( length(r$w_hat_boot),   B )
  expect_equal( length(r$w48_hat_boot), B )
  
  expect_true( all(r$theta_crs_hat <= 1) )
  expect_true( all(r$theta_vrs_hat <= 1) )
})

context("Output rts.test")

test_that("output rts.test with H0='constant'", {
  r = rts.test(X=X, Y=Y, model="output", H0="constant", B = B)
  expect_equal( length(r$theta_crs_hat), length(firms) )
  expect_equal( length(r$theta_vrs_hat), length(firms) )
  expect_equal( length(r$w_hat_boot),   B )
  expect_equal( length(r$w48_hat_boot), B )
  
  expect_true( all(r$theta_crs_hat <= 1) )
  expect_true( all(r$theta_vrs_hat <= 1) )
})

test_that("output rts.test with H0='non-increasing'", {
  r = rts.test(X=X, Y=Y, model="output", H0="non-increasing", B = B)
  expect_equal( length(r$theta_crs_hat), length(firms) )
  expect_equal( length(r$theta_vrs_hat), length(firms) )
  expect_equal( length(r$w_hat_boot),   B )
  expect_equal( length(r$w48_hat_boot), B )
  
  expect_true( all(r$theta_crs_hat <= 1) )
  expect_true( all(r$theta_vrs_hat <= 1) )
})
