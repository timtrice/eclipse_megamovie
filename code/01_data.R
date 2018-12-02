# ---- libraries ----
library(bigrquery)
library(DBI)
library(dplyr)
library(purrr)
library(readr)

# ---- options ----
options("httr_oauth_cache" = Sys.getenv("httr-oauth-path"))

# ---- vars ----
project <- "bigquery-public-data"
dataset <- "eclipse_megamovie"
billing <- Sys.getenv("bigquery-default-project")

# ---- db-open-con ----
con <-
  dbConnect(
    bigquery(),
    project = project,
    dataset = dataset,
    billing = billing,
    use_legacy_sql = FALSE
  )

tables <- dbListTables(con)

# --- get-tables ----
dfs <-
  tables %>%
  map(.f = ~tbl(con, .x)) %>%
  map(.f = collect) %>%
  setNames(tables)

# ---- save-data ----
save(dfs, file = here::here("./data/data.RData"))

# ---- db-close-con ----
dbDisconnect(con)
