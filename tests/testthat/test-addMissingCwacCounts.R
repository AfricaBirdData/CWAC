test_that("we receive an error for non-South African sites", {
  counts <- suppressWarnings(getCwacSiteCounts("03113954"))
  expect_error(addMissingCwacCounts(counts),
               regexp = "This function currently only takes count data from South African sites. See details in ?addMissingCwacCounts",
               fixed = TRUE)
})


