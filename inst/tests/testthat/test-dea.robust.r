
data("dea_hospitals", package="rDEA")

H12 = subset(dea_hospitals, year == 12)
H12[is.na(H12)] = 0

## choosing inputs and outputs for analysis
firms = 1:50
X = H12[firms, c('x1', 'x2', 'x3', 'x5')]
Y = H12[firms, c('y1', 'y2')]
W = H12[firms, c('w1', 'w2', 'w3', 'w5')]

context("Input DEA robust")

test_that("input DEA robust with variable RTS", {
  dr.input = dea.robust(X=X, Y=Y, model="input", RTS="variable", B=20)
  expect_equal( length(dr.input$bias),          length(firms) )
  expect_equal( length(dr.input$theta_hat),     length(firms) )
  expect_equal( length(dr.input$theta_hat_hat), length(firms) )
  expect_equal( length(dr.input$theta_ci_low),  length(firms) )
  expect_equal( length(dr.input$theta_ci_high), length(firms) )
  expect_equal( nrow(dr.input$theta_hat_star),  length(firms) )
  expect_equal( ncol(dr.input$theta_hat_star),  20 )
  
  expect_true( all(dr.input$bias >= 0) )
  expect_true( all(dr.input$ci_low <= dr.input$ci_high) )
})


