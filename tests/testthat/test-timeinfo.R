test_that("timeinfo works", {
    info = timeinfo()
    expect_true("timestr" %in% colnames(info)) 
    expect_true(nrow(info) == 1)
})
