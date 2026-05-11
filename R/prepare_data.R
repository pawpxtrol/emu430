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
  library(lubridate)
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

# Parse date cells that arrive as plain text (Excel serials, DMY strings, ISO, …).
parse_date_from_text <- function(s) {
  s <- str_squish(as.character(s))
  n <- length(s)
  out <- rep(as.Date(NA), n)
  valid <- !is.na(s) & nzchar(s) & s != "NA"
  if (!any(valid)) {
    return(out)
  }

  # 1) Pure numeric → Excel serial (common when sheet is read as character)
  sn <- suppressWarnings(as.numeric(s))
  is_serial <- valid & !is.na(sn) & grepl("^[0-9]+(\\.[0-9]+)?$", s) &
    sn >= 20000 & sn <= 80000
  if (any(is_serial, na.rm = TRUE)) {
    out[is_serial] <- as.Date(floor(sn[is_serial]), origin = "1899-12-30")
  }

  # 2) lubridate flexible parsers (handles 1.03.2025, 01/03/2025, etc.)
  rem <- valid & is.na(out)
  if (any(rem, na.rm = TRUE)) {
    out[rem] <- as.Date(suppressWarnings(dmy(s[rem], quiet = TRUE)))
  }
  rem <- valid & is.na(out)
  if (any(rem, na.rm = TRUE)) {
    out[rem] <- as.Date(suppressWarnings(ymd(s[rem], quiet = TRUE)))
  }
  rem <- valid & is.na(out)
  if (any(rem, na.rm = TRUE)) {
    out[rem] <- as.Date(suppressWarnings(ymd_hms(s[rem], quiet = TRUE)))
  }

  # 3) Explicit DMY with dashes (after normalising separators)
  rem <- valid & is.na(out)
  if (any(rem, na.rm = TRUE)) {
    norm <- str_replace_all(s[rem], "[./]", "-")
    out[rem] <- suppressWarnings(as.Date(norm, format = "%d-%m-%Y"))
    still <- rem & is.na(out)
    if (any(still, na.rm = TRUE)) {
      norm2 <- str_replace_all(s[still], "[./]", "-")
      out[still] <- suppressWarnings(as.Date(norm2, format = "%Y-%m-%d"))
    }
  }

  out
}

read_one <- function(path) {
  # Text pass: reliable for mama / araç / personel strings
  df_txt <- read_excel(path, col_types = rep("text", 7))
  if (ncol(df_txt) < 7) {
    warning("Skipping ", basename(path), " (fewer than 7 columns).")
    return(NULL)
  }

  # Native Excel date in column 1 (POSIXct/Date); string dates become NA here
  df_date <- read_excel(
    path,
    col_types = c("date", "text", "text", "text", "text", "text", "text")
  )

  tarih <- as.Date(df_date[[1]])
  raw1 <- str_squish(df_txt[[1]])
  miss <- is.na(tarih) & !is.na(raw1) & nzchar(raw1) & raw1 != "NA"
  if (any(miss)) {
    tarih[miss] <- parse_date_from_text(raw1[miss])
  }

  tibble(
    tarih = tarih,
    ilce = str_squish(df_txt[[2]]),
    mahalle_sokak = str_squish(df_txt[[3]]),
    besleme_noktasi_sayisi = readr::parse_number(df_txt[[4]], na = c("", "-", "NA")),
    mama_text = str_squish(df_txt[[5]]),
    arac_text = str_squish(df_txt[[6]]),
    personel_text = str_squish(df_txt[[7]]),
    source_file = basename(path)
  ) |>
    mutate(
      mama_kg = readr::parse_number(mama_text, locale = locale(decimal_mark = ",")),
      arac_sayisi = case_when(
        arac_text %in% c("-", "", NA_character_) ~ NA_real_,
        str_detect(arac_text, regex("^[Yy]")) ~
          readr::parse_number(str_remove(arac_text, regex("^[Yy]"))),
        TRUE ~ readr::parse_number(arac_text, na = c("", "-", "NA"))
      ),
      personel_sayisi = readr::parse_number(personel_text, na = c("", "-", "NA"))
    ) |>
    select(
      tarih, ilce, mahalle_sokak,
      besleme_noktasi_sayisi, mama_kg,
      arac_sayisi, personel_sayisi,
      source_file
    )
}

feeding <- purrr::map_dfr(files, read_one)

feeding <- feeding |>
  filter(!is.na(tarih)) |>
  mutate(
    yil = as.integer(format(tarih, "%Y")),
    ay = as.integer(format(tarih, "%m")),
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
message("Months (yil_ay): ", paste(sort(unique(feeding$yil_ay)), collapse = ", "))
message("İlçe count: ", length(unique(feeding$ilce)))
