#' @keywords internal
"_PACKAGE"

#' pgscatalogcolors: Color Palettes for PGS Catalog Ancestry Groups
#'
#' Provides color palettes mapped to the PGS Catalog ancestry classification
#' system. Each ancestry acronym (e.g., EUR, AFR, EAS, SAS) is associated with
#' a specific hex color, enabling consistent visualizations across studies.
#'
#' @section Main functions:
#' \describe{
#'   \item{[pgscatalog_cols()]}{Get hex colors by ancestry acronym}
#'   \item{[pgscatalog_pal()]}{Get an interpolating palette function}
#'   \item{[pgscatalog_scale_values()]}{Get a named vector for scale_*_manual()}
#'   \item{[pgscatalog_ancestry_info()]}{Get full metadata table}
#'   \item{[scale_color_pgscatalog()]}{ggplot2 colour scale}
#'   \item{[scale_fill_pgscatalog()]}{ggplot2 fill scale}
#' }
#'
#' @name pgscatalogcolors-package
#' @importFrom stats setNames
NULL
