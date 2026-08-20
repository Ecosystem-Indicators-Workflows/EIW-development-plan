# Shared loader for the EIW registry. Both appendices source this so sheet and
# column names live in one place.
# install.packages(c("readxl", "dplyr", "tidyr", "stringr"))

library(readxl)
library(dplyr)
library(tidyr)
library(stringr)

EIW_XLSX <- file.path("data", "EIW_Master_Tracebility_Matrix.xlsx")

# Fixes the order tabs and tables appear in.
EIW_CATEGORIES <- c(
  "Adaptability",
  "Reproducibility and transparency",
  "Classification and vocabularies",
  "Data discovery",
  "Documentation and training",
  "Accessibility",
  "Validation"
)

# Reads a matrix tab straight from the workbook, so whatever is marked in the
# sheet is what the book renders. Category band rows are dropped by keeping
# only rows whose first column is a requirement ID.
eiw_read_matrix <- function(path, sheet, key) {
  raw <- read_excel(path, sheet = sheet, col_types = "text")
  names(raw) <- str_trim(names(raw))          # "UC02 " has a trailing space
  
  raw |>
    rename(req_id = `Requirement ID`) |>
    filter(str_detect(req_id, "^[A-Z]{2}[0-9]{2}$")) |>
    select(-any_of(c("Category", "Description", "Story count"))) |>
    pivot_longer(-req_id, names_to = key, values_to = "mark") |>
    filter(!is.na(mark), str_trim(mark) != "") |>
    mutate(mark = str_trim(mark))
}

eiw_load <- function(path = EIW_XLSX) {
  
  requirements <- read_excel(path, sheet = "Requirements") |>
    rename(req_id = ID, category = Category, description = Description) |>
    mutate(category = factor(category, levels = EIW_CATEGORIES))
  
  use_cases <- read_excel(path, sheet = "Use_Cases") |>
    rename(uc_id = ID, title = Title)
  
  user_stories <- read_excel(path, sheet = "User_Stories") |>
    rename(us_id = ID, story = `User Story`,
           satisfies = `Satisfies (Requirement IDs)`)
  
  list(
    requirements = requirements,
    use_cases    = use_cases,
    user_stories = user_stories,
    link_uc_req  = eiw_read_matrix(path, "Matrix_ReqxUseCase",      "uc_id"),
    link_us_req  = eiw_read_matrix(path, "Matrix_ReqxUserStories",  "us_id"),
    uc_ids       = use_cases$uc_id
  )
}

# Rebuilds a wide tick table from the long form. Blank means the pairing was
# never marked; any other mark is passed through as written in the sheet.
eiw_tick_matrix <- function(links, id_col, row_ids, col_ids, col_key) {
  
  grid <- expand.grid(row_id = row_ids, col_id = col_ids,
                      stringsAsFactors = FALSE)
  names(grid) <- c(id_col, col_key)
  
  as_tibble(grid) |>
    left_join(links, by = c(id_col, col_key)) |>
    mutate(mark = coalesce(mark, "")) |>
    select(all_of(c(id_col, col_key)), mark) |>
    pivot_wider(names_from = all_of(col_key), values_from = mark)
}

# Warns when a matrix tab and its matching text column disagree, so hand edits
# to one cannot silently drift from the other.
eiw_check <- function(eiw) {
  from_matrix <- eiw$link_uc_req |>
    filter(mark == "\u2713") |>
    transmute(uc_id, req_id)
  
  from_column <- eiw$use_cases |>
    transmute(uc_id, req_id = str_extract_all(`Requirements Exercised`,
                                              "[A-Z]{2}[0-9]{2}")) |>
    unnest(req_id)
  
  only_matrix <- anti_join(from_matrix, from_column, by = c("uc_id", "req_id"))
  only_column <- anti_join(from_column, from_matrix, by = c("uc_id", "req_id"))
  
  tibble(
    check = c("Ticks in matrix only", "Links in Use_Cases column only"),
    n     = c(nrow(only_matrix), nrow(only_column))
  )
}