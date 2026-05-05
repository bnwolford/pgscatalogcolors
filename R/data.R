#' PGS Catalog Ancestry Color Definitions
#'
#' Named vectors mapping ancestry acronyms to hex colors and full names.
#' Based on the PGS Catalog ancestry documentation:
#' \url{https://www.pgscatalog.org/docs/ancestry/}
#'
#' @name pgscatalog_colors
NULL

.pgscatalog_env <- new.env(parent = emptyenv())

.pgscatalog_env$ancestries <- c(
  "Aboriginal Australian",
  "African American or Afro-Caribbean",
  "African unspecified",
  "Asian unspecified",
  "Central Asian",
  "East Asian",
  "European",
  "Greater Middle Eastern",
  "Hispanic or Latin American",
  "Native American",
  "Not Reported",
  "Oceanian",

  "Other",
  "Other admixed ancestry",
  "South Asian",
  "South East Asian",

  "Sub-Saharan African",
  "Multi-Ancestry including Europeans",
  "Multi-Ancestry excluding Europeans"
)

.pgscatalog_env$colors <- c(
  ABO = "#999999",
  AAM = "#F9DA49",
  AFR = "#F9DA49",
  ASN = "#B25928",
  CAS = "#B25928",
  EAS = "#68AD57",
  EUR = "#377EB8",
  MID = "#5DCBCF",
  HIS = "#D1352B",
  AMR = "#999999",
  NON = "#BBBBBB",
  OCE = "#999999",
  OTH = "#999999",
  ADA = "#999999",
  SAS = "#984EA4",
  SEA = "#B25928",
  SAF = "#F9DA49",
  MIE = "#E887BD",
  MEE = "#EF8632"
)

.pgscatalog_env$unique_abbrev <- c(
  "ABO", "AAM", "AFR", "ASN", "CAS", "EAS", "EUR", "MID",
  "HIS", "AMR", "NON", "OCE", "OTH", "ADA", "SAS", "SEA",
  "SAF", "MIE", "MEE"
)

.pgscatalog_env$pop_abbrev <- c(
  "DIV", "AFR", "AFR", "ASN", "ASN", "EAS", "EUR", "MID",
  "HIS", "DIV", "NON", "DIV", "DIV", "DIV", "SAS", "ASN",
  "AFR", "MIE", "MEE"
)

.pgscatalog_env$pop_colors <- stats::setNames(
  c("#999999", "#F9DA49", "#F9DA49", "#B25928", "#B25928", "#68AD57",
    "#377EB8", "#5DCBCF", "#D1352B", "#999999", "#BBBBBB", "#999999",
    "#999999", "#999999", "#984EA4", "#B25928", "#F9DA49", "#E887BD",
    "#EF8632"),
  c("DIV", "AFR", "AFR", "ASN", "ASN", "EAS", "EUR", "MID",
    "HIS", "DIV", "NON", "DIV", "DIV", "DIV", "SAS", "ASN",
    "AFR", "MIE", "MEE")
)
