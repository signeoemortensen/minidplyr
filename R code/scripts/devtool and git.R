
# devtools and git --------------------------------------------------------

#
#install.packages(
#  c(
#    "devtools",
#    "usethis",
#    "roxygen2",
#    "testthat",
#    "spelling"
#  )
#)


library(devtools)
library(usethis)
library(roxygen2)
library(testthat)
library(spelling)


# code along --------------------------------------------------------------

usethis::use_description(list(License = "GPL-3"))
usethis::use_namespace()
dir.create("R")
usethis::use_package_doc()
usethis::use_roxygen_md()
usethis::use_testthat()
spelling::spell_check_setup()
usethis::use_github_action('check-standard')


# create branch
# new branch -> development

# make scripts for functions
usethis::use_r("filter_function")
usethis::use_r("select_function")

# make functions in scripts
# see scripts

# test
iris_test <- iris
iris_test
iris_test[1:5, ]

# use filter to select rows
filter2(iris_test, 1:5)

test_type <- filter2(iris_test, 1:5)
str(test_type)
# use select to select rows
select2(iris_test, "Sepal.Length")

select2(iris, 1:2)
# build package -----------------------------------------------------------

# git -> install


# code along - unit test --------------------------------------------------

usethis::use_test("filter_function")
usethis::use_test("selection_function")


# documentation
# Ctrl + shift + alt i R til insert skeleton
?select2
?filter2

#build documentation
devtools::document()

# check
?select2
?filter2

# Test if it work
# build -> check 

### fejl i load til github (install, check and merge step)


devtools::check()

## continuos check




