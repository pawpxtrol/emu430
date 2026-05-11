#!/usr/bin/env Rscript
# Builds data/feeding_clean.RData from ALL monthly Excel files in data/raw/.
# Run from project root:  Rscript R/prepare_data.R

options(warn = 1)

suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(stringr)
  library(readr)
  library(here)
  library(purrr)
})

raw_dir <- here::here("data", "raw")
files <- sort(list.files(raw_dir, pattern = "^hayvan_besleme_.*\\.xlsx$", full.names = TRUE))

if (length(files) == 0) {
  stop(
    "No raw Excel files found under: ", raw_dir,
    "\nExpected names like hayvan_besleme_YYYY_MM.xlsx"
  )
}

message("Found ", length(files), " monthly Excel file(s).")

# Parse "1.03.2025" -> Date, or accept already-Date / POSIXct values.
parse_mixed_date <- function(x) {
  if (inherits(x, c("Date", "POSIXct", "POSIXt"))) return(as.Date(x))
  # As character; try DMY with "." or "/" or "-"
  s <- str_squish(as.character(x))
  s <- str_replace_all(s, "[./-]", "-")
  d <- suppressWarnings(as.Date(s, format = "%d-%m-%Y"))
  miss <- is.na(d) & !is.na(s) & nzchar(s) & s != "NA"
  # Try YMD as fallback
  if (any(miss)) {
    d2 <- suppressWarnings(as.Date(s[miss], format = "%Y-%m-%d"))
    d[miss] <- d2
  }
  d
}

read_one <- function(path) {
  # Read everything as text so we can normalize ourselves
  df <- read_excel(path, col_types = "text")
  if (ncol(df) < 7) {
    warning("Skipping ", basename(path), " (fewer than 7 columns).")
    return(NULL)
  }
  names(df)[1:7] <- c(
    "tarih_raw", "ilce", "mahalle_sokak",
    "besleme_noktasi_text", "mama_text", "arac_text", "personel_text"
  )

  df |>
    mutate(
      tarih = parse_mixed_date(tarih_raw),
      ilce = str_squish(ilce),
      mahalle_sokak = str_squish(mahalle_sokak),
      besleme_noktasi_sayisi = readr::parse_number(besleme_noktasi_text, na = c("", "-", "NA")),
      mama_kg = readr::parse_number(mama_text, locale = locale(decimal_mark = ",")),
      arac_text = str_squish(arac_text),
      personel_text = str_squish(personel_text),
      arac_sayisi = case_when(
        arac_text %in% c("-", "", NA_character_) ~ NA_real_,
        str_detect(arac_text, regex("^[Yy]")) ~
          readr::parse_number(str_remove(arac_text, regex("^[Yy]"))),
        TRUE ~ readr::parse_number(arac_text, na = c("", "-", "NA"))
      ),
      personel_sayisi = readr::parse_number(personel_text, na = c("", "-", "NA")),
      source_file = basename(path)
    ) |>
    select(
      tarih, ilce, mahalle_sokak,
      besleme_noktasi_sayisi, mama_kg,
      arac_sayisi, personel_sayisi,
      source_file
    )
}

feeding <- purrr::map_dfr(files, read_one)

# Drop rows where we could not parse the date (very rare, would be a header reread)
feeding <- feeding |>
  filter(!is.na(tarih)) |>
  mutate(
    yil = as.integer(format(tarih, "%Y")),
    ay  = as.integer(format(tarih, "%m")),
    yil_ay = format(tarih, "%Y-%m")
  ) |>
  arrange(tarih, ilce, mahalle_sokak)

dir.create(here::here("data"), showWarnings = FALSE)
out_rdata <- here::here("data", "feeding_clean.RData")
save(feeding, file = out_rdata)

message("Wrote ", nrow(feeding), " rows from ", length(unique(feeding$source_file)),
        " file(s) to ", out_rdata)
message("Date range: ", min(feeding$tarih, na.rm = TRUE), " -> ",
        max(feeding$tarih, na.rm = TRUE))
message("İlçe count: ", length(unique(feeding$ilce)))
