

# function that select columns --------------------------------------------



#' select2 - function that select columns
#'
#' @param data data.frame
#' @param vector columns
#'
#' @returns data.frame with selected columns
#' @export
#'
#' @examples
#' 
#' select2(iris, 1:2)
#' 
#' 
#' 
#' 
#' 
select2 <- function(data, 
                      vector)
  {
    data[, vector]
  }
