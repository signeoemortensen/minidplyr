############################################################
# A297/07 Advanced R
# Day 1 - Student Version
# Guided worksheet
############################################################

# This script follows the Day 1 slides. Run the code chunks
# together with the presentation, and complete the exercises
# in the marked spaces.



# ==========================================================
# Introduction and course overview
# ==========================================================

# Goal:
# - Get an overview of the course structure, schedule, and expectations


# ----------------------------------------------------------
# Notes
# ----------------------------------------------------------




# ==========================================================
# Section 1. Good practices and project setup
# ==========================================================

# Goal:
# - Set up an RStudio project following good practice conventions


# ----------------------------------------------------------
# R code style: naming, spacing, indenting
# ----------------------------------------------------------

# Be smart and consistent with naming. Compare:
# dat1, dat2, dat3, fct1()                       <- what do these contain/do?
# patients_raw, patients_clean, summarise_bmi()  <- self-explanatory
#
# Pick ONE naming convention and stick to it (not all conventions work
# equally well for both variables and functions):
# snake_case      -> patient_age
# camelCase       -> patientAge
# BigCamelCase    -> PatientAge  (usually reserved for e.g. S4 classes)

# Comments can explain WHY or WHAT - e.g. why is this here, not just
# what does complete.cases() do (that's what ?complete.cases is for):
example_data <- data.frame(x = c(1, NA, 3), y = c(4, 5, NA))
# Remove rows with any missing value, since lm() cannot handle NAs
complete_data <- example_data[complete.cases(example_data), ]
complete_data

# Spacing:
# - space before/after '=' when naming arguments, and around most
#   operators (+, -, <-, ==, etc.)
# - NO space around ^, :, ::, :::, $, [, [[, !!, !!!, ?
# - always a space AFTER a comma, never before
mean(c(1, 2, NA), na.rm = TRUE)   # not: mean(c(1,2,NA),na.rm=TRUE)
# dplyr::filter(...)                # not: dplyr :: filter(...)
# x[1:3]                            # not: x[1 : 3]

# Parentheses: no space around () for functions, DO surround if/for/while
# with a space, and put a space after the closing ) of a function call
# before the next token:
if (nrow(complete_data) > 0) {
  message("At least one complete row")
}

# The pipe %>% (or base R's |>) always gets a space before it, and
# usually a new line after:
c(1, 2, NA, 4) |>
  mean(na.rm = TRUE)

# Indenting: curly braces {} are the most important hierarchy in R -
# always indent their contents by 2 spaces (or a tab), consistently

# Long lines are harder to read - aim for ~80 characters or less; if
# you need more, consider a helper function or refactoring


# ----------------------------------------------------------
# A few more style rules
# ----------------------------------------------------------

# 1. Use <- for assignment, not =  (= is for naming function arguments)
x <- 5          # not: x = 5

# 2. Don't end lines with ; and avoid multiple commands on one line
y <- 10
z <- 15
# not: y <- 10; z <- 15

# 3. Only use return() for an early return - let the last expression
#    of a function be its return value otherwise
add_one <- function(x) {
  if (is.na(x)) {
    return(NA)   # early return
  }
  x + 1
}
add_one(NA)
add_one(4)

# 4. Use "double quotes" for strings, not 'single quotes'
name <- "Aarhus"    # not: name <- 'Aarhus'

# 5. Use TRUE and FALSE, not the abbreviations T and F (T/F are just
#    variables that can be reassigned to something else - TRUE/FALSE cannot)
is_case <- TRUE      # not: is_case <- T


# ----------------------------------------------------------
# Code organisation
# ----------------------------------------------------------

# Start a script with a short header: title, description, author, date
############################################################
# Title:       Patient data cleaning
# Description: Import, clean, and summarise the patient cohort
# Author:      Your name
# Date:        YYYY-MM-DD
############################################################

# Split a long script into sections with Ctrl+Shift+R (Cmd+Shift+R on
# Mac) - this inserts a foldable, navigable section header like:
# Load packages ----

# The {styler} package can auto-format code to these conventions for you:
# install.packages("styler")
# styler::style_file("my_script.R")    # reformat a whole file
# styler::style_text("x=1+2")          # reformat a snippet


# ----------------------------------------------------------
# RStudio essentials
# ----------------------------------------------------------

# The default layout has (roughly): Source (top-left, your scripts),
# Console (bottom-left, where code actually runs), Environment/History
# (top-right), and Files/Plots/Packages/Help/Viewer (bottom-right) -
# plus an AI Assistant pane in newer RStudio versions.

# Useful hotkeys:
# Ctrl+Click / Cmd+Click        -> jump to a function's source code
# Ctrl+Enter / Cmd+Return       -> run the current line/selection
# Ctrl+Shift+A / Shift+Cmd+A    -> reformat the current selection
# Ctrl+Shift+C / Shift+Cmd+C    -> comment/uncomment selected lines
# Ctrl+Shift+K / Shift+Cmd+K    -> knit/render a document
# Ctrl+Shift+B / Shift+Cmd+B    -> build a package, website, or book
# Ctrl+Shift+M / Shift+Cmd+M    -> insert the pipe operator (%>% or |>)
# Tools > Keyboard Shortcuts has many more.

# Data can be loaded interactively via the Environment pane's
# "Import Dataset" button (point-and-click, generates the code for
# you) - or non-interactively with e.g. read.table()/read.csv(), or
# fread() from data.table. Non-interactive is more reproducible, but
# you need to already know the shape of the data.

# Code diagnostics (Tools > Global Options > Code > Diagnostics)
# underline potential problems as you type:
# x  a comma is missing
# !  a function argument doesn't match what the function expects
# i  formatting doesn't follow the style conventions above


# ----------------------------------------------------------
# RStudio Projects
# ----------------------------------------------------------

# An RStudio Project (.Rproj) keeps everything for one piece of work
# together: input data, scripts, results, figures, etc. in one folder.
#
# Key benefits:
# - a meaningful, self-contained folder structure
# - the working directory automatically switches to the project folder
# - previously open files reopen automatically when you reopen the project
# - the History and Files panes only show project-specific content
# - some settings are project-specific, e.g. Git settings (next section!)
#
# Create one via: File > New Project > New Directory (or Existing
# Directory) > New Project


# ----------------------------------------------------------
# Exercise
# ----------------------------------------------------------

# Create a new RStudio Project for this course (if you haven't
# already). Inside it, create a script with a title/description/
# author/date header, add a couple of section headers with
# Ctrl+Shift+R, and write a few lines of deliberately "bad style" code
# - then run styler::style_file() on it and compare.

# Your code here:




# ==========================================================
# Section 2. Version control with Git/GitHub
# ==========================================================

# Goal:
# - Connect RStudio to Git/GitHub and understand a basic version control workflow


# ----------------------------------------------------------
# What is Git, and why use it?
# ----------------------------------------------------------

# Have you ever:
# - made a change, realised it was a mistake, and wanted to revert it?
# - lost code, or only had a backup that was too old?
# - wanted to submit a change to someone else's code?
# - wanted to share your code, or let someone else work on it with you?
# ...then Git is for you.
#
# Git is often sold as a collaboration tool - and it is - but it's
# also valuable for solo work:
# - a complete version history of every change
# - safe experimentation (you can always go back)
# - reproducibility
# - backup
# - an easy way to undo a mistake or an analysis that led nowhere
#
# Working with Git from day one sets you up to collaborate later, and
# is a professional standard in most research software environments.


# ----------------------------------------------------------
# Setting up Git credentials (Personal Access Token)
# ----------------------------------------------------------

# RStudio needs a way to authenticate with GitHub. We use a Personal
# Access Token (PAT) rather than your GitHub password.

# Opens the GitHub page to create a token (classic):
# (or manually: GitHub > Settings > Developer settings > Personal
# access tokens > Tokens (classic))
usethis::create_github_token()

# !! Copy the token or write it down before leaving the page - GitHub
# will never show it to you again after that !!

# Back in RStudio, store the token:
gitcreds::gitcreds_set()
# Paste the token into the prompt (in the Console/Terminal), and
# overwrite existing credentials if asked.

# Check that everything is set up correctly:
gh::gh_token_exists()     # can credentials be found at all?
gitcreds::gitcreds_get()  # are the stored credentials correct?
gh::gh_whoami()           # who does GitHub think you are?


# ----------------------------------------------------------
# Create a repository, and clone it locally
# ----------------------------------------------------------

# On GitHub: create a new repository (e.g. "minidplyr"), and tick
# "Add a README file" so the repo isn't completely empty.
#
# In RStudio: File > New Project > Version Control > Git, then paste
# the repository's URL. RStudio infers the project name from the URL -
# just pick a convenient folder to put it in.


# ----------------------------------------------------------
# Using Git day to day: RStudio's Git panel
# ----------------------------------------------------------

# The Git tab (top-right pane, next to Environment/History) is where
# you'll do most day-to-day Git work in RStudio:
# - Diff: see exactly what changed, line by line
# - tick files, then Commit: save a snapshot with a message
# - Push: send your commits to GitHub
# - Pull: fetch other people's commits from GitHub
# - History: browse previous commits
# - the branch dropdown (top-right of the pane): create/switch branches
#
# A typical cycle: make changes -> Diff to review -> stage + Commit
# with a short, meaningful message -> Push.


# ----------------------------------------------------------
# When the GUI isn't enough: the terminal
# ----------------------------------------------------------

# Merging branches is NOT available in the RStudio Git panel - for
# that (and a few other things), use the Terminal tab instead of the
# R console:

# Switch to the main branch:
# git switch master
#
# Merge changes from feature-branch into the current branch:
# git merge feature-branch
#
# Push the updated local branch to GitHub:
# git push origin master
#
# Remove the feature branch locally, once it's no longer needed:
# git branch -d feature-branch
#
# Remove it on GitHub too, if it exists there:
# git push origin --delete feature-branch


# ----------------------------------------------------------
# Exercise
# ----------------------------------------------------------

# Set up your GitHub PAT if you haven't already (see above), then
# create a small repository, clone it into an RStudio Project, make a
# change, and Diff/Commit/Push it.

# Your code here:




# ==========================================================
# Section 3. Useful AI assistants in coding
# ==========================================================

# Goal:
# - Get familiar with AI coding assistants and how to use them responsibly


# ----------------------------------------------------------
# Types of AI assistance
# ----------------------------------------------------------

# There are (roughly) 3 types of AI coding tools:
#
# 1. Next Edit Suggestion (NES) / autocomplete
#    e.g. GitHub Copilot, Posit Assistant - predicts the next line(s)
#    as you type. Free for students, teachers, and researchers.
#    Opinion from class: NES is not always a great alternative to a
#    well-crafted regular autocomplete - it can hallucinate variable
#    names that don't exist in your script.
#
# 2. External AI chats
#    e.g. ChatGPT, Claude, Gemini, Copilot chat (non-exhaustive list).
#    Workflow: you paste code into the chat and ask for help -> you
#    get a response -> you try it out.
#    Limitation: it only knows what you tell it - it has no access to
#    the names of your objects, their types, or their contents unless
#    you paste that information in too.
#
# 3. Session-aware / agentic AI tools
#    e.g. Posit AI, Anthropic, OpenAI, Gemini, and others, integrated
#    directly into RStudio. Requires RStudio integration and an API
#    key for billing - a normal chat subscription is not enough.
#    Workflow: you ask for help in a script -> it reads the script and
#    helps you -> it returns a modified script. This is the
#    "(largely) autonomous, revises independently" category.


# ----------------------------------------------------------
# Writing good instructions for AI
# ----------------------------------------------------------

# Many tools let you set standing instructions/a system prompt. Example:
#
# "I would like <tool> to respond in a clear, concise, and formal
# academic style. Please avoid informal language and provide examples
# relevant to my field of research. I do not want sugarcoated
# responses. Assume the role of my PostDoc supervisor when answering
# my questions. Provide constructive critique, detailed explanations,
# and suggestions that help me improve my work. If appropriate, offer
# alternative approaches or interpretations in line with how a
# supervisor would guide me through the research process. When
# providing feedback or corrections, offer 2-4 examples. Avoid overly
# persuasive or sales-oriented language, focusing on neutrality,
# precision, and academic standards. If any ambiguity exists, ask any
# clarifying questions you think are necessary and tailor responses to
# my specific research context. I expect you to tell me if my ideas or
# suggestions are bad, but I expect you to tell me why they are bad
# and how they can be improved. The primary research topic is
# statistical genetics."
#
# Adjust the tone, role, and research topic to your own context.


# ----------------------------------------------------------
# Showcase 1: debugging
# ----------------------------------------------------------

# Open the script "Showcase1_debugging.R" (provided separately), which
# produces only NAs after merging some data. Ask your AI assistant:
#
# "I have the script Showcase1_Debugging.R. I only get NAs after
# merging the data. Can you please help me debug and fix the problem?"


# ----------------------------------------------------------
# Showcase 2: explain code
# ----------------------------------------------------------

# Open the script "Showcase2_explainCode.R" (provided separately), and ask:
#
# "What does dplyr::across() actually do here, step by step?"


# ----------------------------------------------------------
# Showcase 3: an open-ended request
# ----------------------------------------------------------

# In a brand new, empty script, prompt your AI assistant with:
#
# "With the mtcars data set, I would like to test whether mpg (miles
# per gallon) is associated with any of the other variables in the
# mtcars dataset"
#
# Two things to take away from this showcase:
# 1. With great power comes great responsibility.
# 2. Few things are as dangerous as an error-free script (given to you
#    by an AI) - "runs without error" is not the same as "correct".


# ----------------------------------------------------------
# Exercise
# ----------------------------------------------------------

# Try Showcase 3 yourself with your AI assistant of choice. Before
# running anything it suggests, read through the code it produces and
# ask yourself: do I understand every line? Would I be comfortable
# explaining this analysis choice to a supervisor?

# Your code here:




# ==========================================================
# Section 4.1. Advanced programming concepts in R I
# ==========================================================

# Goal:
# - Recognise common R pitfalls and understand why they happen
# - Understand types, coercion, and R's core data structures


# ----------------------------------------------------------
# Common mistakes and gotchas: floating-point equality
# ----------------------------------------------------------

# Why can equality be surprising? What do you expect this to return?
(0.1 + 0.2) == 0.3

# Compare the printed value and the internal approximation
x <- 0.3
x
print(x, digits = 22)

# R prints the shortest readable representation of a number,
# not necessarily its exact internal value
print(12345.6789)

# Instead of using ==, use all.equal() to test if two objects are
# equal up to some tolerance (1.5e-8 by default)
all.equal(0.1 + 0.2, 0.3)

# Forcing an exact comparison (tolerance = 0) reveals the tiny
# floating-point difference instead of TRUE
all.equal(0.1 + 0.2, 0.3, tolerance = 0)
all.equal(0.1 + 0.2, 0.3, tolerance = 1e-16)
all.equal(0.1 + 0.2, 0.3, tolerance = 1e-15)   # loose enough -> TRUE again

# Base R: compare with a tolerance instead of ==
all.equal(0.1 + 0.2, 0.4)

# Use isTRUE() when you need a single logical value
isTRUE(all.equal(0.1 + 0.2, 0.3))
isTRUE(all.equal(0.1 + 0.2, 0.4))

# dplyr alternative
dplyr::near(0.1 + 0.2, 0.3)

# Where you'll actually use == every day: filtering rows, counting matches
patients <- data.frame(
  id = c("P1", "P2", "P3", "P4"),
  sex = c("F", "M", "F", "F"),
  diagnosis = c("asthma", "diabetes", "asthma", "hypertension")
)
patients[patients$sex == "F", ]
sum(patients$diagnosis == "asthma")


# ----------------------------------------------------------
# Common mistakes and gotchas: function arguments and ...
# ----------------------------------------------------------

# Same inputs, different functions - what do you expect these to return?
min(0, 5, 10)
max(0, 5, 10)
mean(0, 5, 10)
median(0, 5, 10)

# Compare how each function's arguments are defined
args(min)
args(max)
args(mean)
args(median)

# Safer approach: use a vector and pass the vector to the functions
values <- c(0, 5, 10)
min(values)
max(values)
mean(values)
median(values)

# ... and named arguments
values <- c(0, 5, 10, NA)
max(values)
max(values, na.rm = TRUE)

ages <- c(45, 62, 38, NA, 71)
mean(ages, na.rm = TRUE)
sd(ages, na.rm = TRUE)
summary(ages)


# ----------------------------------------------------------
# Common mistakes and gotchas: sample(), 1:n, and safer sequences
# ----------------------------------------------------------

# sample() on a vector works as expected
sample(1:10)

# But what happens when you pass a single number?
sample(10)
sample(10.1)

# Risky when x may have length 1
x <- 10
sample(x)

# Safer when we explicitly mean the values inside x
x <- 10
sample(x, size = length(x))

# The : (colon) problem
n <- 10
1:n - 1
1:(n - 1)

# seq_len() avoids the trap above
seq_len(n)
seq_len(n - 1)

# What does : return when n is 0?
n <- 0
1:n
seq_len(n)


# ----------------------------------------------------------
# Types and coercion
# ----------------------------------------------------------

# R's atomic types
logi_vec <- FALSE
int_vec <- 1:5
dbl_vec <- c(2.5, 12.568)
char_vec <- "abc"

typeof(logi_vec)
typeof(int_vec)
typeof(dbl_vec)
typeof(char_vec)

# Coercion: an atomic vector can only hold one type
c(FALSE, 1:5)
c(1:5, 10.5)
c(1:5, "a")

# Lists can hold different types (unlike atomic vectors)
my_list <- list(
  id = 1,
  name = "Patient A",
  high_risk = TRUE,
  values = c(4.1, 5.3, 6.2)
)
my_list
str(my_list)


# ----------------------------------------------------------
# Exercise 1.4 (5 min)
# ----------------------------------------------------------

# Use automatic type coercion to convert this boolean matrix to:
# - a numeric matrix with 0s and 1s
# - an integer matrix with 0s and 1s
mat_logical <- matrix(
  sample(c(TRUE, FALSE), 12, replace = TRUE),
  nrow = 3
)

# Your code here:

num_matrix <- as.numeric(mat_logical)
int_matrix <- as.integer(mat_logical)

# Correct

mat_numeric <- mat_logical + 0
mat_numeric

mat_integer <- mat_logical + 0L
mat_integer
# ----------------------------------------------------------
# Data structures: vectors, matrices, arrays, and data frames
# ----------------------------------------------------------

# A vector becomes a matrix by adding a 'dim' attribute
vec <- 1:12
vec
dim(vec) <- c(3, 4) # 3 row, 4 colums
vec
class(vec)

# Changing 'dim' again turns the matrix into an array
dim(vec) <- c(3, 2, 2)
vec
class(vec)

# Data frames are lists of equal-length vectors
set.seed(42)
cohort <- data.frame(
  age = round(c(rnorm(50, 45, 8), rnorm(50, 58, 9), rnorm(50, 65, 7))),
  bmi = round(c(rnorm(50, 24, 2), rnorm(50, 28, 3), rnorm(50, 31, 3)), 1),
  sbp = round(c(rnorm(50, 118, 8), rnorm(50, 135, 10), rnorm(50, 152, 12))),
  dbp = round(c(rnorm(50, 76, 6), rnorm(50, 85, 7), rnorm(50, 92, 8))),
  diagnosis = factor(rep(c("control", "mild", "severe"), each = 50))
)
head(cohort)

# dim() gives rows and columns, length() gives the number of columns (it's a list)
dim(cohort)
length(cohort)


# ----------------------------------------------------------
# Data structures and accessors ([, [[, $)
# ----------------------------------------------------------

# The [ accessor: subset, keeps the same general structure
x <- 1:5
x[2:3]
x[2:8]

l <- list(
  a = 1,
  b = "I love R",
  c = matrix(1:6, nrow = 2)
)
l[2:3]

head(cohort[3:4])

# Subsetting data frames with [
cohort[3:4]      # Columns 3 and 4
cohort[3:4, ]    # Rows 3 and 4
cohort[, 3:4]    # Columns 3 and 4

# R stores matrix elements column-wise
mat <- matrix(1:12, nrow = 3)
mat
mat[1]           # vector-style extraction - still just a vector internally
mat[4:9]

mat[2:3]
mat[2:3, ]
mat[, 2:3]
mat[2, 3]

# The [[ accessor: extract a single element
x <- 1:10
x[[3]]

l <- list(
  a = 1,
  b = "I love R",
  c = matrix(1:6, nrow = 2)
)
l[[2]]
l[["c"]]

# The $ accessor: convenient name-based extraction (lists and data frames only)
l$b
head(cohort$diagnosis)
head(cohort[["diagnosis"]])




# ----------------------------------------------------------
# Exercise 2.4 (15 min)
# ----------------------------------------------------------

# The 'study' object contains different types of R objects.
study <- list(
  participant_ids = c(
    "P001", "P002", "P003", "P004", "P005"
  ),
  participants = data.frame(
    id = c("P001", "P002", "P003", "P004", "P005"),
    age = c(45, 62, 38, 71, 55),
    sex = c("F", "M", "F", "M", "F")
  ),
  vitals = matrix(
    c(
      128, 78, 68,
      145, 90, 74,
      132, 82, 70,
      160, 95, 80,
      118, 72, 65
    ),
    nrow = 5,
    byrow = TRUE,
    dimnames = list(
      c("P001", "P002", "P003", "P004", "P005"),
      c("sbp", "dbp", "pulse")
    )
  )
)

# 1. Use str(study) to explore its structure.
#    Identify the vector, matrix, and data frame.

# Your code here:
str(study)
typeof(study)
class(study)

# vector of chr
# data.frame of id (char), age (num, and sex (chr))
#list of vitals (id and vital)

# 2. Extract:
# - participant IDs 2-4
# - the 'participants' data frame
# - the 'age' column from 'participants'
# - all vital signs for participant "P004"
# - systolic blood pressure ('sbp') for all participants

# Your code here:

# id 2 to 4
id_2_to_4 <- study$participant_ids[study$participant_ids[2:4]]
# correct
study$participant_ids[2:4]

# participants df
df_participants <- study$participants
# correct
study$participants

# age column
age_participants <- df_participants$age
# correct
study$participants$age

# vital signs from "P004"
P004_vitals <- study$vitals[study$vitals["P004"]]
# correct
study$vitals["P004",]


# 3. Compare - what is the difference between the three results?
study["participants"]
study[["participants"]]
study$participants



# 4. Combine accessors to extract:
# - ages of participants 2-4
# - the systolic BP of participant "P004"
# - the sex of participant "P003"

# Your code here:

study$participants$age[2:4]
study$vitals["P004", "sbp"]
study$participants$sex[
  study$participant_ids == "P003"
]

study$vitals
study$participants
# ==========================================================
# Section 4.2. Advanced programming concepts in R II
# ==========================================================

# Goal:
# - Understand environments, lexical scoping, and name masking in R
# - Get a reference tour of useful base R (and a few CRAN) functions


# ----------------------------------------------------------
# Environments and scoping
# ----------------------------------------------------------

# R looks for a name in the current environment, then in the parent
# environment, and so on, until it finds it (or reaches the empty environment)
f <- function() {
  x <- 2
  g <- function() {
    x + 1
  }
  g()
}
f()

# x is not defined inside g(), so R looks in g()'s parent environment - f()


# ----------------------------------------------------------
# Lexical scoping, dynamic lookup, and name masking
# ----------------------------------------------------------

# Dynamic lookup: R looks for values when the function is RUN, not when
# it is created - so this function can be defined even though x doesn't exist yet
fct <- function() {
  x + 1
}
# fct()  # would error: object 'x' not found, until x is defined somewhere

# A fresh start: every function call gets a brand-new environment
fct <- function() {
  if (!exists("x")) x <- 1 else x <- x + 1
  x
}
fct()
fct()

# Super assignment <<- modifies a variable in a parent environment instead
# (or creates one in the global environment if it doesn't exist yet)
fct <- function() {
  if (!exists("x")) x <<- 1 else x <<- x + 1
  x
}
fct()
fct()

# Functions versus variables: R skips non-function objects when looking
# for a function of the same name
f1 <- function(x) x + 10
f2 <- function() {
  f1 <- 30
  f1(f1)
}
f2()

# Name masking: names defined inside a function mask names defined outside it
fct <- function() {
  x + 1
}
fct()
x <- 10
fct()
x <- 15
fct()

# ...but a function can also be fully independent of the outside environment
fct <- function() {
  x <- 5
  x + 1
}
x <- 15
fct()

# Functions can shadow other functions (here, the base R c() function)
c <- function(...) {
  "not the c() you expected"
}
c(1, 2, 3)

# Remove the shadowing object to get the base function back
rm(c)
c(1, 2, 3)


# ----------------------------------------------------------
# Useful base R functions
# ----------------------------------------------------------

# ?topic / help(topic): open documentation
# example(topic): run the Examples section of a help page
# str(object): compactly display the structure of an object
str(iris)

# ls(): list objects in the current environment
ls()
# rm(list = ls())  # clears your WHOLE environment - don't run this now

# Sequences: seq(), seq_len(), seq_along()
seq(1, 10, by = 2)
seq(1, 100, length.out = 10)
seq(from = 1, to = 5, by = 1)
seq_len(5)
seq_along(21:24)

# Repetition: rep(), rep_len(), rep.int()
rep.int(1:4, 2)
rep(1:4, times = 4:1)
rep(1:4, length.out = 6)
rep_len(1:4, 6)
rep(1:4, each = 2)

# Test it!
rep(1:4, times = 2)
rep(c("control", "treatment"), times = c(2, 5))

# Sorting and ordering: sort(), order(), rank()
age <- c(52, 34, 61, 34)
sort(age)

x <- c(30, 10, 20)
order(x)

# order() breaks ties using a second vector
name <- c("Alice", "Bob", "Carol", "David")
age <- c(25, 20, 25, 20)
score <- c(80, 95, 70, 85)
order(age)
order(age, score)

rank(age)
rank(age, ties.method = "first")

# Finding extremes: which.min() / which.max() return the POSITION, not the value
bmi <- c(24.1, 31.5, 27.8, 35.2, 29.6)
which.max(bmi)
which.min(bmi)

auc <- c(0.71, 0.76, 0.74, 0.79)
best_model <- which.max(auc)
best_model

# Removing duplicates: unique()
diagnosis <- c("Depression", "Schizophrenia", "Depression", "ADHD", "ADHD")
unique(diagnosis)

set.seed(1)
data <- data.frame(
  patient_id = 1:10,
  sex = sample(c("Female", "Male"), 10, replace = TRUE),
  case_status = sample(c("Case", "Control"), 10, replace = TRUE, prob = c(0.3, 0.7)),
  diagnosis = sample(c("Depression", "Schizophrenia", "ADHD", "Bipolar disorder"), 10, replace = TRUE),
  ICD10_code = sample(c("F32", "F20", "F90", "F31"), 10, replace = TRUE)
)
data

unique(data$ICD10_code)
length(unique(data$patient_id))

# Counting observations: table()
sex <- c("Female", "Male", "Female", "Female", "Male")
table(sex)
table(data$case_status)
table(data$case_status, data$sex)

# Sampling: sample()
sample(1:1000, 20)

# Bootstrap sampling: replace = TRUE allows the same value to be drawn twice
sample(data$patient_id, replace = TRUE, 5)

# Creating a train/test split
set.seed(123)
train <- sample(seq_len(nrow(data)), size = round(0.8 * nrow(data)))
train
data[train, ]

# Rounding for reporting: round() vs signif()
beta <- c(0.03421, -0.12765, 0.98215)
round(beta, 2)

p_values <- c(0.1247, 0.004812, 0.00003168, 0.0000000264)
round(p_values, digits = 3)     # small values round to 0.000
signif(p_values, digits = 3)    # keeps 3 meaningful digits instead

# pmin() / pmax(): element-wise, unlike min()/max()
death_date <- c(8, 12, 15)
study_end <- c(10, 10, 10)
pmin(death_date, study_end)

# Capping impossible values, e.g. a predicted probability above 1
predicted_risk <- c(0.23, 0.81, 1.12)
pmin(predicted_risk, 1)

# Every combination of two vectors: outer() and expand.grid()
ages <- c(20, 40, 60)
interval <- c(1, 2, 5)
outer(ages, interval, "+")

expand.grid(
  prevalence = c(0.05, 0.10),
  sample_size = c(5000, 10000),
  heritability = c(0.2, 0.4)
)

# Aligning datasets: match()
gwas <- c("rs10", "rs20", "rs30")
annotation <- c("rs20", "rs10", "rs30")
match(gwas, annotation)

# Filtering by membership: %in%
data$diagnosis %in% c("Depression", "Schizophrenia")
psy_data <- data[data$diagnosis %in% c("Depression", "Schizophrenia"), ]
psy_data

# Set operations: intersect(), union(), setdiff()
cohort1 <- c(101, 102, 103, 104)
cohort2 <- c(103, 104, 105)
intersect(cohort1, cohort2)
union(cohort1, cohort2)
setdiff(cohort1, cohort2)   # order matters! try setdiff(cohort2, cohort1)

# Working with text: paste() and paste0()
paste("I", "am", "Tahereh")
paste0("I", "am", "Tahereh")
paste0("PC", 1:10)

# Building a regression formula automatically
pcs <- paste0("PC", 1:10)
formula(paste(
  "depression ~ prs +", paste(pcs, collapse = " + ")
))

cohorts <- c("iPSYCH", "UKB", "FinnGen")
paste0(cohorts, "_results.csv")

# Cleaning names: sub()
traits <- c("UKB_BMI", "UKB_MDD", "UKB_ADHD")
sub("UKB_", "", traits)

# Splitting a dataset by a grouping variable: split()
set.seed(1)
data <- data.frame(
  patient_id = 1:9,
  hospital = rep(c("Hospital_A", "Hospital_B", "Hospital_C"), each = 3),
  BMI = round(rnorm(9, mean = 27, sd = 4), 1)
)
hospital <- split(data, data$hospital)
hospital

# Checking a whole vector at once: any() and all()
sbp <- c(120, 135, 128, NA, 142)
any(is.na(sbp))
all(sbp > 0, na.rm = TRUE)

# any()/all() are naturally suited to if() conditions
age <- c(45, 62, 38, 71, 55)
if (any(age < 18)) {
  warning("Dataset contains participants under 18")
} else {
  message("Age check passed: all participants are adults")
}

# ----------------------------------------------------------
# Exercise 3.4 (25-30 min): useful base R functions
# ----------------------------------------------------------

# Overview:
# Work with a small simulated multicentre health-study dataset.
# The goal is NOT to practise one function at a time - for each task,
# decide which base R tool from this session is the right fit.
# There is often more than one correct solution.
#
# Rules:
# - Use base R for this exercise. Do not use dplyr.
# - Reuse objects you create in earlier parts.
# - Try to solve each task before looking back at the examples from class.


# --- Setup: run this once ---

set.seed(123)

patients <- data.frame(
  patient_id = paste0("P", 1:24),
  hospital = rep(
    c("Hospital_A", "Hospital_B", "Hospital_C"),
    length.out = 24
  ),
  age = sample(
    20:80,
    24,
    replace = TRUE
  ),
  bmi = round(
    rnorm(24, mean = 27, sd = 4),
    1
  ),
  sbp = sample(
    seq(100, 170, by = 5),
    24,
    replace = TRUE
  ),
  case_status = sample(
    c("Case", "Control"),
    24,
    replace = TRUE,
    prob = c(0.35, 0.65)
  ),
  diagnosis = sample(
    c(
      "Depression",
      "Schizophrenia",
      "ADHD",
      "Bipolar disorder"
    ),
    24,
    replace = TRUE
  ),
  planned_followup = sample(
    5:12,
    24,
    replace = TRUE
  )
)
patients

# A second dataset contains genetic information for only some participants
genetic_ids <- sample(
  patients$patient_id,
  18
)

genetics <- data.frame(
  patient_id = genetic_ids,
  genetic_score = round(
    rnorm(18, mean = 0, sd = 1),
    3
  )
)
genetics

# Assume the study finishes after 8 years
study_end <- 8


# --- Part 1: understand the data ---

# 1. Inspect the structure of patients.
# 2. Find the different diagnoses represented in the study.
# 3. Count the number of participants in each:
#    - hospital
#    - case/control group
# 4. Create a two-way frequency table of hospital by case_status.
# 5. Check whether:
#    - any participant has BMI > 35
#    - all participants have a positive age

# Write your code here



# --- Part 2: find and order observations ---

# 6. Which participant has the highest systolic blood pressure (sbp)?
#    Return both the position of that participant in the dataset,
#    and the corresponding patient_id.
# 7. Display the participants from youngest to oldest, without
#    changing the original patients object.
# 8. Sort first by age and, when ages are tied, by BMI.
# 9. Calculate the rank of each participant's BMI.

# Write your code here



# --- Part 3: follow-up time ---

# Participants cannot be observed beyond the end of the study.
# Create a new variable in patients called observed_followup.
# For each participant, it should contain the smaller of
# planned_followup and study_end, e.g.:
#   planned follow-up = 11, study end = 8 -> observed follow-up = 8
#
# Then check whether any participant still has an observed
# follow-up greater than 8 years.

# Write your code here



# --- Part 4: random train/test split ---

# Randomly select approximately 20% of the participants for a test dataset.
# 1. Store the selected row indices in test_ind
# 2. Create test_data using those row indices
# 3. Create train_data containing all remaining participants
# 4. Check how many participants are in each dataset
#
# Think about it: why is set.seed() useful before random sampling?
# What happens if you call sample() repeatedly without resetting the seed?

# Write your code here



# --- Part 5: link the patient and genetic data (without using a join) ---

# 10. Find participant IDs that occur in both datasets.
# 11. Find study participants who have no genetic data.
# 12. Check whether all participants in patients have genetic data.
# 13. For every participant in patients, find their position in genetics.
#     Participants absent from genetics should have NA.
# 14. Create an object called genetics_aligned with:
#     - all patient_id values in the same order as patients
#     - the corresponding genetic_score
#     - NA when a participant has no genetic data
#
#     The beginning should conceptually look like:
#     patient_id   genetic_score
#     P1           ...
#     P2           NA
#     P3           ...

# Write your code here



# --- Part 6: work with grouped data using split() ---

# Split patients into one data frame per hospital. The result should
# be a list similar to:
#   $Hospital_A ...
#   $Hospital_B ...
#   $Hospital_C ...
#
# Then:
# 1. Inspect the names of the resulting list.
# 2. Extract the data frame for Hospital_B.
# 3. Calculate the mean BMI for Hospital_B.
# 4. Extract the BMI vector for Hospital_C.
# Use the list accessors discussed earlier in the course.

# Write your code here



# --- Part 7: build all study-design scenarios ---

sample_size <- c(500, 1000, 5000)
case_fraction <- c(0.2, 0.4)
followup_years <- c(2, 5, 10)

# 15. Create a data frame containing every possible combination of
#     these three parameters.
# 16. How many study-design scenarios are there?
# 17. Add a variable called scenario_name with names such as:
#     N500_case0.2_followup2
#     N1000_case0.4_followup5
#     Generate the names automatically.

# Write your code here



# --- Part 8: final quality-control check ---

# Write code that checks all of the following:
# 18. Are all patient_id values unique?
# 19. Are all participants aged 18 or older?
# 20. Are all observed_followup values less than or equal to the study end?
# 21. Does the dataset contain at least one "Case" and at least one "Control"?
# 22. Which participant IDs failed to link to genetics?
#
# Finally, create one logical value called ready_for_analysis.
# It should be TRUE only if:
# - IDs are unique
# - all participants are adults
# - all observed follow-up values are valid
# - both case and control participants are present
# - every participant has genetic data

# Write your code here



# --- Optional challenge: which model is best? ---

auc <- c(
  model_A = 0.71,
  model_B = 0.76,
  model_C = 0.74,
  model_D = 0.79
)

# Without manually inspecting the values:
# 1. identify the best-performing model
# 2. return its name
# 3. return its AUC
# 4. round the reported AUC to two decimal places

# Write your code here



# --- Functions you may find useful (not all needed for every task) ---
# str()                    seq(), seq_len()          rep(), rep_len()
# sort(), order(), rank()  which.min(), which.max()  unique(), table()
# sample()                 round(), pmin(), pmax()   expand.grid()
# match(), %in%            intersect(), union(), setdiff()
# paste(), paste0()        split()                   any(), all()
# length(), names(), nrow()
#
# Strategy: for each question, first ask -
# 1. What kind of object do I have?
# 2. What result do I need?
# 3. Do I need a value, a position, a logical vector, or a subset?
# 4. Which function from this session returns that type of result?




# ----------------------------------------------------------
# Useful non-base functions
# ----------------------------------------------------------

# skimr::skim(): a more informative summary() (install.packages("skimr"))
skimr::skim(iris)

# glue::glue(): readable string templating (install.packages("glue"))
trait <- "Depression"
glue::glue("Results/{trait}_GWAS.csv")
glue::glue("Analysing {nrow(data)} participants.")

# gtools::mixedsort(): natural sorting of names and codes (install.packages("gtools"))
pcs <- c("PC1", "PC10", "PC11", "PC2", "PC3")
sort(pcs)               # plain sort() treats these as text
gtools::mixedsort(pcs)  # sorts the way a human would expect




# ==========================================================
# Section 5. Introduction to R Markdown
# ==========================================================

# Goal:
# - Understand R Markdown and Quarto, and how they compare
# - Create, run, and render a basic Quarto document


# ----------------------------------------------------------
# R Markdown vs Quarto
# ----------------------------------------------------------

# R Markdown: the {rmarkdown} package, converts .Rmd files into HTML/PDF/Word/...
# Quarto: a standalone, language-agnostic publishing system that does the
# same job and more (R, Python, Julia, Observable JS)
# Same core idea in both: plain text + code chunks + a rendering engine
# = a reproducible document

# Needed once, to render to PDF:
install.packages("tinytex")
tinytex::install_tinytex()


# ----------------------------------------------------------
# Anatomy of a Quarto (.qmd) document
# ----------------------------------------------------------

# Every .qmd file has three parts:
# 1. YAML header (between --- lines): title, author, output format, ...
# 2. Markdown text: headings, formatting, links
# 3. Code chunks: R code that runs when the document is rendered, ```{r} ... ```


# ----------------------------------------------------------
# Creating, running, and rendering a Quarto document
# ----------------------------------------------------------

# Create a new .qmd file:
# File > New File > Quarto Document...
# (or the new-file icon above the Source pane, or a blank file saved as .qmd)

# Insert a code chunk:
# - type the delimiters ```{r} and ``` manually, or
# - use the "insert chunk" icon in the Source pane toolbar, or
# - in the visual editor, type / and choose "R Code Chunk"

# Run a chunk: click the green play icon in its top-right corner,
# or use the keyboard shortcut (Ctrl+Enter / Cmd+Enter for one line,
# Ctrl+Shift+Enter / Cmd+Shift+Enter for the whole chunk)

# Render the whole document: click "Render" in the toolbar
# (tick "Render on Save" to re-render automatically whenever you save)


# ----------------------------------------------------------
# Markdown syntax basics (used inside the .qmd file, not this .R script)
# ----------------------------------------------------------

# # Big heading
# ## Smaller heading
# ### Even smaller heading
# *italic*, **bold**, and `inline code`
# - bullet list item
# 1. numbered list item
#
# Remember the blank line: pandoc uses blank lines to tell where one
# block (e.g. a paragraph) ends and the next (e.g. a list) begins


# ----------------------------------------------------------
# Chunk options
# ----------------------------------------------------------

# Set with a #| line at the top of a chunk, e.g. #| echo: false
# echo: false     -> hides the code, keeps the output
# eval: false     -> shows the code, does not run it
# warning: false  -> suppresses warnings in the rendered document
# message: false  -> suppresses package/status messages
# fig-cap: "..."  -> caption text for a figure


# ----------------------------------------------------------
# One source, many output formats
# ----------------------------------------------------------

# Change one line in the YAML header to switch output format:
# format: html      # webpage
# format: pdf       # requires LaTeX/TinyTeX
# format: docx      # Word, for co-authors who need track changes
# format: revealjs  # slides


# ----------------------------------------------------------
# Exercise 1.5 (30 min): make your own website with Quarto
# ----------------------------------------------------------

# 1. Create an empty GitHub repository named [YOURGITHUBNAME].github.io
#    (replace [YOURGITHUBNAME] with your own GitHub username).
#    Leave it empty - do not initialise it with a README, licence, or .gitignore.
#
# 2. In RStudio: File > New Project > New Directory > Quarto Website.
#    Give it a name and location, and make sure "Create a git repository"
#    is checked. This scaffolds _quarto.yml, index.qmd, and about.qmd for you.
#
# 3. Connect the local project to your GitHub repository
#    (run in the Terminal tab, not the R console):
#    git remote add origin https://github.com/[YOURGITHUBNAME]/[YOURGITHUBNAME].github.io.git
#    git add .
#    git branch -M main
#    git commit -m "Initial Quarto website"
#    git push -u origin main
#
# 4. Preview the site locally (run in the Terminal tab):
#    quarto preview
#
# 5. Edit _quarto.yml (site title and navigation bar), index.qmd (home page),
#    and about.qmd (about page). Add a new page if you like: create
#    [page_name].qmd and add it under navbar in _quarto.yml.
#
# 6. Commit and push your changes as you go (Terminal tab):
#    git add .
#    git commit -m "Update website content"
#    git push
#
# 7. Publish to GitHub Pages (Terminal tab):
#    quarto publish gh-pages
#    (the first run may ask you to authenticate with GitHub; confirm in your
#    repository's Settings > Pages that the source is set to the gh-pages branch)




# ==========================================================
# End-of-day reflection
# ==========================================================

# 1. One thing I understood well today:
# _________________________________________________

# 2. One thing that is still unclear:
# _________________________________________________

# 3. One command or concept I think I will use again:
# _________________________________________________
