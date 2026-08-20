
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
