# Load necessary packages
library(readxl)
library(dplyr)
library(janitor)
library(purrr)
library(lubridate)
library(stringr)
library(openxlsx)

# Define the path to your Excel file
file_path <- "DataWork/DataSets/Raw/Ghana/Department Staff list - Without names.xlsx"

# Get the first two sheet names
sheet_names <- excel_sheets(file_path)

# Function to read each sheet, clean names, remove rows with all NA, and add "department" column
read_and_clean_sheet <- function(sheet_name) {
  # Read the sheet
  data <- read_excel(file_path, sheet = sheet_name) %>%
    # Clean column names to be lowercase and in snake_case
    clean_names(case = "snake") %>%
    select(sex, current_grade, date_of_birth, date_of_first_appointment, senior_junior_staff)
  
  # Remove rows where all columns are NA
  data <- data %>%
    filter(if_all(everything(), ~ !is.na(.)))
  
  # Add a column named "department" with the sheet name
  data <- data %>%
    mutate(department = sheet_name) 
  
  # Standardize date formats by replacing different separators with "-"
  data <- data %>%
    mutate(
      date_of_birth_aux = str_replace_all(date_of_birth, "[/.-]", "-"),
      date_of_first_appointment_aux = str_replace_all(date_of_first_appointment, "[/.-]", "-")
    ) %>%
    # Attempt to parse dates in specific columns using parse_date_time to handle multiple formats
    mutate(
      date_of_birth_parsed = parse_date_time(date_of_birth_aux, orders = c("ymd", "mdy", "dmy", "Ymd")),
      date_of_first_appointment_parsed = parse_date_time(date_of_first_appointment_aux, orders = c("ymd", "mdy", "dmy", "Ymd"))
    ) %>%
    # Use janitor::excel_numeric_to_date() if parse_date_time() results in NA
    mutate(
      date_of_birth = case_when(
        !is.na(date_of_birth_parsed) ~ date_of_birth_parsed,
        TRUE ~ excel_numeric_to_date(as.numeric(date_of_birth))
      ),
      date_of_first_appointment = case_when(
        !is.na(date_of_first_appointment_parsed) ~ date_of_first_appointment_parsed,
        TRUE ~ excel_numeric_to_date(as.numeric(date_of_first_appointment))
      )
    ) %>%
    # Remove auxiliary columns
    select(-date_of_birth_aux, -date_of_first_appointment_aux, -date_of_birth_parsed, -date_of_first_appointment_parsed)
  
  return(data)
}

# Apply the function to each sheet and combine all sheets into a single data frame
department_staff <- lapply(sheet_names, read_and_clean_sheet) %>% bind_rows()


# add date 

department_staff_clean <- department_staff %>%
  # Calculate years of service
  mutate(years_of_service = as.numeric(difftime(Sys.Date(), date_of_first_appointment, units = "days")) / 365.25) %>%
  # Standardize 'senior_junior_staff' to lowercase and trim spaces
  mutate(
    senior_junior_staff = str_to_lower(str_trim(senior_junior_staff)),
    senior_junior_staff = if_else(senior_junior_staff == "hunior", "junior", senior_junior_staff),
    # Standardize 'sex' to "Male" or "Female"
    sex = case_when(
      str_to_lower(str_trim(sex)) %in% c("m", "male") ~ "Male",
      str_to_lower(str_trim(sex)) %in% c("f", "female") ~ "Female",
      TRUE ~ sex # Keep original value if it doesn't match "Male" or "Female"
    )
  ) %>% 
  filter(sex != "Sex") 

department_staff_clean <- department_staff_clean %>%
  mutate(
    date = Sys.Date(),  # Adding today's date column
    age = as.numeric(difftime(Sys.Date(), date_of_birth, units = "days")) / 365.25,  # Calculating age in years
    ID = row_number()
  )

department_staff <- department_staff_clean  %>% 
  select(ID, sex, current_grade, senior_junior_staff, department, years_of_service)

department_staff_age <- department_staff_clean  %>% 
  select(ID, age)

write.xlsx(department_staff, "DataWork/DataSets/Raw/Ghana/department_staff_list.xlsx")
write.xlsx(department_staff_age, "DataWork/DataSets/Raw/Ghana/department_staff_age.xlsx")
