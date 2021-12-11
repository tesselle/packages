# Set CRAN package list
tesselle <- c("arkhe", "dimensio", "folio", "kairos", "khroma", "tabula")

# Get RStudio CRAN mirror data
if (!file.exists("downloads.RData")) {
  downloads <- NULL
  from <- as.Date("2018-10-18")
} else {
  load("downloads.RData")
  from <- as.Date(max(downloads$date)) + 1
}
if (Sys.Date() - from >= 0) {
  last <- adjustedcranlogs::adj_cran_downloads(
    packages = tesselle,
    from = as.character(from),
    to = "last-day"
  )
  ## Write data
  downloads <- rbind(downloads, last) |>
    dplyr::filter( # One day before the date of the first release
      (package == "khroma" & date >= "2018-10-18") |
        (package == "tabula" & date >= "2018-12-02") |
        (package == "arkhe" & date >= "2019-12-17") |
        (package == "gamma" & date >= "2020-09-17") |
        (package == "folio" & date >= "2021-02-11") |
        (package == "dimensio" & date >= "2021-04-21") |
        (package == "kairos" & date >= "2021-11-07")
    )

  ## Downloads per month
  downloads_month <- downloads |>
    dplyr::mutate(
      month = lubridate::floor_date(date, "month")
    ) |>
    dplyr::group_by(package, month) |>
    dplyr::summarize(
      count = sum(count),
      adjusted_downloads = sum(adjusted_downloads),
      .groups = "drop_last"
    ) |>
    dplyr::ungroup() |>
    dplyr::group_by(package) |>
    dplyr::mutate(
      total_count = cumsum(count),
      total_downloads = cumsum(adjusted_downloads)
    ) |>
    dplyr::ungroup()
  save(downloads, downloads_month, file = "downloads.RData")
}
