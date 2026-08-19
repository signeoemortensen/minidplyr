############################################################
## A297/07 Advanced R - Day 2 mini project (student version)
## Day 2 focus: combining, cleaning, reshaping, joining, and
## summarising realistic, messy health data
## dplyr, tidyr, stringr, lubridate
############################################################
##
## Scenario:
## A small diabetes-screening study ran at two sites (Aarhus and
## Odense). Each site sent you its own patient list, and a separate
## visits log and a lab-results file arrived in inconvenient shapes.
## Your job is to combine, clean, reshape, and join everything into
## one analysis-ready table - and to check your join at every step,
## the way we did in the joining-datasets session.
##
############################################################


## =========================================================
## Helpful functions for today
## =========================================================
##
## Combining tables:
##   bind_rows()             -> stack rows from compatible tables
##   *_join()                -> match rows between tables using a key
##   join_by()                -> specify join keys explicitly
##
## Checking a join:
##   count() %>% filter(n > 1)  -> find duplicate keys
##   anti_join()               -> find unmatched records
##   nrow()                    -> check row counts before/after
##
## Cleaning text:
##   trimws()                 -> remove leading/trailing whitespace
##   tolower()                 -> standardise case
##   str_pad()                 -> pad a string to a fixed width, e.g. with zeros
##   str_c() / paste0()        -> concatenate strings together
##   as.numeric()              -> convert (already-clean) text to a number
##
## Dates:
##   parse_date_time()         -> parse dates given in multiple formats at once
##   time_length() / interval() -> calculate an age or a duration
##
## Reshaping:
##   pivot_longer()             -> wide format to long format
##   separate_wider_delim()     -> split one column into several
##
## dplyr verbs:
##   filter(), mutate(), select(), arrange(), rename(),
##   summarise(), group_by(), row_number()
##
## IMPORTANT: if you don't remember how a function works, use ?function_name
##
## =========================================================


## ---------- 0) Load packages and data ----------

library(tidyverse)
library(lubridate)

## Site A sent their patient list with a stray space around the site name:
site_a_patients <- data.frame(
  patient_id = c("A1", "A2", "A3", "A4", "A5", "A6"),
  birth_date = c("1975-03-12", "1968/11/02", "22-Jul-1990",
                 "1982-01-30", "1959-09-09", "05-Feb-2000"),
  sex = c("F", "M", "F", "F", "M", "M"),
  site = rep(" Aarhus ", 6)
)

## Site B sent theirs with the site name in lowercase:
site_b_patients <- data.frame(
  patient_id = c("B1", "B2", "B3", "B4", "B5"),
  birth_date = c("1970-06-15", "1988-12-20", "1995/02/14",
                 "14-Mar-1977", "1962-08-08"),
  sex = c("M", "F", "F", "M", "F"),
  site = rep("odense", 5)
)

## The visits log - notice not every patient above has a visit yet,
## and one visit belongs to a patient ("C1") that isn't in either
## site's patient list at all:
visits <- data.frame(
  patient_id = c("A1", "A1", "A2", "A3", "A3", "A4",
                 "B1", "B1", "B2", "C1"),
  visit_date = c("2023-01-10", "2023-07-14", "2023-02-20",
                 "2023-03-05", "2023-09-01", "2023-04-11",
                 "2023-01-22", "2023-08-19", "2023-05-30", "2023-06-17"),
  treatment_info = c("MetforminA_dose_500", "MetforminA_dose_1000", "Placebo_dose_0",
                     "MetforminB_dose_850", "MetforminB_dose_850", "Placebo_dose_0",
                     "MetforminA_dose_500", "MetforminA_dose_750", "Placebo_dose_0",
                     "MetforminB_dose_850")
)

## Lab results arrived wide, one row per patient, one column per visit.
## Notice one reading came back as "999" - the lab's error code for a
## failed assay, not a real HbA1c value - which is why both columns
## below are text instead of numbers:
labs_wide <- data.frame(
  patient_id = c("A1", "A2", "A3", "A4", "B1", "B2"),
  hba1c_visit1 = c("7.2", "6.8", "8.1", "6.5", "7.9", "6.2"),
  hba1c_visit2 = c("6.9", "6.7", "999", "6.4", "7.5", "6.0")
)


## ---------- 1) Combine and clean the patient lists ----------

## Q1: Combine site_a_patients and site_b_patients into one data frame
## called patients.

## Write your code below:

# look at the data
site_a_patients
site_b_patients

# similar columns -> i can use bind_rows() 
patients <- bind_rows(site_a_patients, site_b_patients)

#check data
patients # looks ok
str(patients) # data frame confirmed
nrow(site_a_patients) # 6
nrow(site_b_patients) # 5
nrow(patients) # 11
duplicated(patients$patient_id) # all FALSE


## Q2: The site column has inconsistent whitespace and capitalisation.
## Create a cleaned version called site_clean (trim whitespace, and
## make the capitalisation consistent), and store it back in patients.
## Check the result with count().
## Hint: trimws(), tolower()

## Write your code below:

patients <- patients %>%
  mutate(
    site_clean = tolower(trimws(site))
  )

patients %>%
  count(site_clean)



## Q3: Inspect patients. How many patients are there in total? What
## variables does it have, and what are their types?

## Write your code below:

patients %>% 
  count(patient_id) # 11 in total

nrow(patients) # 11 in total

## ---------- 2) Parse the messy birth dates ----------

## Q4: birth_date is given in three different formats. Parse it into
## a proper Date column (overwrite birth_date, or store as a new
## column - your choice).
## Hint: parse_date_time() can take several formats at once via the
## orders = argument, e.g. orders = c("ymd", "dmy")

## Write your code below:

# look at data
patients

# new birthdate
?parse_date_time


patients <- patients %>%
  mutate(
    birth_date_clean = 
      parse_date_time(birth_date, orders = c("ymd", "dmy", "mdy"))
  )

#check
patients


## Q5: Add a column age_years: each patient's age today, in whole years.
## Hint: time_length(interval(birth_date, today()), "years"), then
## round it down to a whole number.

## Write your code below:

#create age_years
patients <- patients %>% 
  mutate(
    age_years = round(time_length(
      interval(birth_date_clean, today()), "years"))
  ) 

# check
patients

## ---------- 3) Reshape the lab results to long format ----------

## Q6: labs_wide has one row per patient and one column per visit.
## Reshape it to long format: one row per patient per visit, with a
## column called visit (containing "visit1"/"visit2") and a column
## called hba1c. Store the result as labs_long.
## Hint: pivot_longer(), and look at the names_prefix argument to
## strip the "hba1c_" part of the column names automatically.

## Write your code below:

# look at data
labs_wide

labs_long <- labs_wide %>% 
  pivot_longer(
    col = c(hba1c_visit1, hba1c_visit2),
    names_to = "visit", # er det hvor skal navn på gammle kolonner hen???
    names_prefix = "hba1c_", #remove things that start with "hba1c_"
    values_to = "hba1c" # er det hvor selve værdierne skal hen?
  )

labs_long


## Q6b: Because of the "999" error code, hba1c came through as text
## (check with str(labs_long) or class(labs_long$hba1c)). Replace any
## "999" values with a proper NA, then convert hba1c to numeric. Store
## the result back in labs_long.
## Hint: this is the same two-step pattern as the "99+" clean-up in
## the tidyverse exercises: fix the sentinel value first, THEN convert
## the type - as.numeric("999") would otherwise just give you a
## harmless-looking 999 instead of a missing value.

## Write your code below:

str(labs_long)
class(labs_long$hba1c)

labs_long 


labs_long <- labs_long %>%
  mutate(
    hba1c = na_if(hba1c, "999"), # tænk NA hvis hba1c = "999"
    hba1c = as.numeric(hba1c)
  )

# check again
labs_long


## ---------- 4) Split the compound treatment column ----------

## Q7: In visits, treatment_info combines the drug name and the dose
## in one string (e.g. "MetforminA_dose_500"). Split it into two
## clean columns: drug and dose_mg (numeric). Store the result back
## in visits.
## Hint: separate_wider_delim(), then convert dose_mg with as.numeric()

## Write your code below:

?separate_wider_delim

# check data
visits

visits <- visits %>% 
  separate_wider_delim(
    treatment_info,
    delim = "_dose_",
    names = c("drug", "dose"))

# make numeric
visits <- visits %>% 
  mutate(dose = as.numeric(dose))

#check
visits


## Q7b: The site also wants a short visit_code for each record: the
## patient_id, an underscore, and a zero-padded sequence number for
## that patient's visits, e.g. patient A1's two visits should become
## "A1_01" and "A1_02". Add visit_code as a new column in visits.
## Hint: group_by(patient_id) and row_number() give you the visit
## sequence (1, 2, ... per patient); str_pad() pads it to width 2 with
## a leading zero; str_c() (or paste0()) glues patient_id, "_", and
## the padded number together. Remember to ungroup() afterwards.

## Write your code below:

?str_pad
?str_c

#check data
visits %>%
  group_by(patient_id) %>%
  ungroup()

#group by patient_id
visits <- visits %>%
  group_by(patient_id) %>%
  mutate(
    visit_code = str_c(
      patient_id,
      "_",
      str_pad(row_number(), width = 2, pad = "0") # 2 tegn langt, 0 skal tilføjes
    )
  ) %>%
  ungroup()

#check data
visits


## ---------- 5) Investigate before joining ----------

## Q8: Before joining patients and visits, answer in a comment:
## - What does one row represent in patients? In visits?
## - What is the key in each table?
## _________________________________________________
## _________________________________________________

visits # one row is one visit -> patient_id is key?
patients # one row is one unique patient -> primary key is patient_id!

## Q9: Check that patient_id is actually unique in patients.

## Write your code below:

unique(patients$patient_id) # 11
nrow(patients) # 11

## Q10: Which patients have no recorded visit at all?
## Hint: anti_join()

## Write your code below:

?anti_join()

# find obs not in 
check_no_visit <- 
  anti_join(
    patients, 
    visits, 
    by = join_by (patient_id)
  )

#check
check_no_visit # "A5, A6, B3-B5" have no visit.
visits


## Q11: Which visit records belong to a patient that does not appear
## in patients at all?

## Write your code below:

#unsure

check_visit_no_patient <- 
  anti_join(
    visits, 
    patients, 
    by = join_by (patient_id)
  )

#check
check_visit_no_patient # C1


## ---------- 6) Join, and verify the join ----------

## Q12: Join the patient information onto every visit record (start
## from visits, so every visit is kept), with an explicit join_by()
## and an appropriate relationship =. Store the result as visits_full.

## Write your code below:

visits_full <- left_join(
  visits,
  patients,
  by = join_by(patient_id)
)

visits_full 



## Q13: Confirm that nrow(visits_full) matches nrow(visits). Does a
## matching row count guarantee that there are no unmatched records
## (like the one you found in Q11)? Why or why not?
## _________________________________________________
## _________________________________________________

## Write your code below:

#check
nrow(visits) #10
nrow(visits_full) #10

# I do not understand the question but I think you need to go look at the data
# and compare - it is not enough to just count.

## ---------- 7) Summarise and report ----------

## Q14: Using labs_long from Q6, calculate the mean HbA1c per patient
## (mean_hba1c), across their available visits.

## Write your code below:

mean_hba1c_per_patient <- labs_long %>% 
  group_by(patient_id) %>% 
  summarise(
    mean_hba1c = mean (hba1c, na.rm = TRUE)
  )

mean_hba1c_per_patient

## Q15: Join this per-patient summary onto patients (keep every
## patient, even those without any lab results). Store as
## patients_summary.

## Write your code below:

patients_summary <- left_join(
  patients,
  mean_hba1c_per_patient,
  by = join_by(patient_id)
)

patients_summary


## Q16: Using patients_summary: keep only patients who have a
## mean_hba1c, group by site_clean, and calculate the mean HbA1c and
## the number of patients per site. Arrange from highest to lowest
## mean HbA1c.

## Write your code below:

?filter


site_summary <- patients_summary %>%
  filter(!is.na(mean_hba1c)) %>%
  group_by(site_clean) %>%
  summarise(
    mean_hba1c = mean(mean_hba1c),
    n_patients = n()
  ) %>%
  arrange(desc(mean_hba1c))

site_summary

#### Q17: Build a final tidy report table from patients_summary
## containing just: patient_id, site (renamed from site_clean),
## age_years, and avg_hba1c (renamed from mean_hba1c).

## Write your code below:

#Did not finish



## ---------- Key takeaways ----------
##
## - Data arriving from multiple sources usually needs stacking
##   (bind_rows()) or joining (*_join()) before it is usable together.
##
## - Text and dates are rarely clean on arrival - inspect before you
##   trust them, and expect more than one format.
##
## - Wide and long are both valid shapes; pivot_longer()/pivot_wider()
##   convert between them depending on what the next step needs.
##
## - A join can run without an error and still be wrong. Row counts
##   matching is a good sign, but only anti_join() and duplicate-key
##   checks actually confirm there is nothing unexpected hiding.
##
## Key principle:
##   Before you trust a join, know what one row represents, know the
##   key, and check it - the same habits from the joining-datasets
##   session apply to every dataset you will ever combine.

#test test test 
#ny test test tst 