#!/usr/bin/env Rscript
# Builds data/feeding_clean.RData from the raw Excel file.
# Run from project root: Rscript R/prepare_data.R

options(warn = 1)

suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(stringr)
  library(readr)
  library(here)
})

raw_path <- here::here("data", "raw", "hayvan_besleme_2024_07.xlsx")
if (!file.exists(raw_path)) {
  stop(
    "Missing raw Excel at: ", raw_path,
    "\nCopy your file to data/raw/hayvan_besleme_2024_07.xlsx (see README)."
  )
}

feeding_raw <- read_excel(
  raw_path,
  col_types = c("date", "text", "text", "numeric", "text", "text", "text")
)

names(feeding_raw) <- c(
  "tarih",
  "ilce",
  "mahalle_sokak",
  "besleme_noktasi_sayisi",
  "mama_text",
  "arac_text",
  "personel_text"
)

feeding <- feeding_raw |>
  mutate(
    ilce = str_squish(ilce),
    mahalle_sokak = str_squish(mahalle_sokak),
    mama_kg = readr::parse_number(mama_text, locale = locale(decimal_mark = ",")),
    arac_text = str_squish(arac_text),
    personel_text = str_squish(personel_text)
  ) |>
  mutate(
    arac_sayisi = case_when(
      arac_text %in% c("-", "", NA_character_) ~ NA_real_,
      str_detect(arac_text, regex("^[Yy]")) ~
        readr::parse_number(str_remove(arac_text, regex("^[Yy]"))),
      TRUE ~ readr::parse_number(arac_text, na = c("", "-", "NA"))
    ),
    personel_sayisi = readr::parse_number(personel_text, na = c("", "-", "NA"))
  ) |>
  select(
    tarih,
    ilce,
    mahalle_sokak,
    besleme_noktasi_sayisi,
    mama_kg,
    arac_sayisi,
    personel_sayisi
  )

dir.create(here::here("data"), showWarnings = FALSE)
out_rdata <- here::here("data", "feeding_clean.RData")
save(feeding, file = out_rdata)

message("Wrote ", nrow(feeding), " rows to ", out_rdata)
