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

eiw_load <- function(path = EIW_XLSX) {
  
  requirements <- read_excel(path, sheet = "Requirements") |>
    rename(req_id = ID, category = Category, description = Description) |>
    mutate(category = factor(category, levels = EIW_CATEGORIES))
  
  use_cases <- read_excel(path, sheet = "Use_Cases") |>
    rename(uc_id = ID, title = Title)
  
  user_stories <- read_excel(path, sheet = "User_Stories") |>
    rename(us_id = ID, story = `User Story`,
           satisfies = `Satisfies (Requirement IDs)`)
  
  # Matrix_Long repeats each requirement once per user group, so collapse it
  # back to one row per use case and requirement.
  link_uc_req <- read_excel(path, sheet = "Matrix_Long") |>
    rename(uc_id = UC_ID, req_id = Req_ID, status = Link_Status) |>
    distinct(uc_id, req_id, status)
  
  # "Satisfies" holds a comma-separated list, so split it to one row each.
  link_us_req <- user_stories |>
    mutate(req_id = strsplit(satisfies, ",\\s*")) |>
    unnest(req_id) |>
    mutate(req_id = str_trim(req_id)) |>
    filter(str_detect(req_id, "^[A-Z]{2}[0-9]{2}$")) |>
    distinct(us_id, req_id)
  
  list(
    requirements = requirements,
    use_cases    = use_cases,
    user_stories = user_stories,
    link_uc_req  = link_uc_req,
    link_us_req  = link_us_req,
    uc_ids       = sort(unique(use_cases$uc_id))
  )
}

# Turns a long link table into a wide tick table. Pass status_col to render
# confirmed links bold; omit it when the links carry no status.
eiw_tick_matrix <- function(links, id_col, row_ids, uc_ids, status_col = NULL) {
  
  grid <- expand.grid(row_id = row_ids, uc_id = uc_ids,
                      stringsAsFactors = FALSE)
  names(grid)[1] <- id_col
  
  grid <- as_tibble(grid) |>
    left_join(links, by = c(id_col, "uc_id"))
  
  # Unmatched pairings must render blank, not NA.
  grid <- if (is.null(status_col)) {
    grid |> mutate(mark = if_else(coalesce(linked, FALSE), "\u2713", ""))
  } else {
    grid |> mutate(mark = case_when(
      coalesce(.data[[status_col]], "") == "Confirmed" ~ "**\u2713**",
      coalesce(.data[[status_col]], "") == "Proposed"  ~ "\u2713",
      TRUE                                             ~ ""
    ))
  }
  
  grid |>
    select(all_of(id_col), uc_id, mark) |>
    pivot_wider(names_from = uc_id, values_from = mark)
}