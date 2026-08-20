

# function that filter rows -----------------------------------------------

#' filter2 - function that filters rows
#'
#' @param data data.frame
#' @param vector rows
#'
#' @returns data.frame with subset of rows
#' @export
#'
#' @examples
#' # test
#' 
#' iris_test <- iris
#' iris_test
#' iris_test[1:5, ]
#' 
#' # use filter to select rows
#' filter2(iris_test, 1:5)
#' 
#' test_type <- filter2(iris_test, 1:5)
#' str(test_type)


filter2 <- function(data, 
                    vector)
  {
  data[vector, ]
}
