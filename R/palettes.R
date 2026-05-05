#' Get PGS Catalog ancestry colors
#'
#' Returns hex color codes for the specified ancestry acronyms. If no
#' acronyms are provided, returns the full named color vector.
#'
#' @param ... Character strings of ancestry acronyms (e.g., "EUR", "AFR", "EAS").
#'   If none provided, all colors are returned.
#' @return A named character vector of hex color codes.
#' @export
#' @examples
#' pgscatalog_cols()
#' pgscatalog_cols("EUR", "AFR", "EAS")
pgscatalog_cols <- function(...) {
  cols <- c(...)
  if (is.null(cols)) {
    return(.pgscatalog_env$colors)
  }
  .pgscatalog_env$colors[cols]
}

#' List available PGS Catalog palettes
#'
#' @return A named list of available palettes.
#' @export
#' @examples
#' pgscatalog_palettes()
pgscatalog_palettes <- function() {
  list(
    unique = .pgscatalog_env$colors,
    population = unique(setNames(
      c("#F9DA49", "#B25928", "#68AD57", "#377EB8", "#5DCBCF",
        "#D1352B", "#999999", "#BBBBBB", "#984EA4", "#E887BD", "#EF8632"),
      c("AFR", "ASN", "EAS", "EUR", "MID",
        "HIS", "DIV", "NON", "SAS", "MIE", "MEE")
    ))
  )
}

#' Get a PGS Catalog color palette function
#'
#' Returns a color palette interpolation function for the specified palette.
#'
#' @param palette Character name of palette. One of "unique" (all 19 ancestry
#'   categories) or "population" (broader population groups). Default: "unique".
#' @param reverse Logical; reverse the palette order? Default: FALSE.
#' @param ... Additional arguments passed to [grDevices::colorRampPalette()].
#' @return A function that takes an integer n and returns n interpolated colors.
#' @export
#' @examples
#' pgscatalog_pal()(5)
#' pgscatalog_pal("population", reverse = TRUE)(8)
pgscatalog_pal <- function(palette = "unique", reverse = FALSE, ...) {
  pals <- pgscatalog_palettes()
  pal <- pals[[palette]]
  if (is.null(pal)) {
    stop("Palette '", palette, "' not found. Available: ",
         paste(names(pals), collapse = ", "))
  }
  if (reverse) pal <- rev(pal)
  grDevices::colorRampPalette(pal, ...)
}

#' Get a named color vector for mapping ancestry acronyms in ggplot2
#'
#' Returns a named vector suitable for use with [ggplot2::scale_color_manual()]
#' or [ggplot2::scale_fill_manual()]. Only returns colors for the acronyms
#' present in your data.
#'
#' @param acronyms Character vector of ancestry acronyms in your data.
#'   If NULL, returns all mappings.
#' @return A named character vector of hex colors keyed by acronym.
#' @export
#' @examples
#' # Use with ggplot2::scale_color_manual
#' my_groups <- c("EUR", "AFR", "EAS", "SAS")
#' pgscatalog_scale_values(my_groups)
pgscatalog_scale_values <- function(acronyms = NULL) {
  all_cols <- .pgscatalog_env$colors
  if (is.null(acronyms)) return(all_cols)
  missing <- setdiff(acronyms, names(all_cols))
  if (length(missing) > 0) {
    warning("Unknown acronyms (will use grey): ",
            paste(missing, collapse = ", "))
    extra <- setNames(rep("#999999", length(missing)), missing)
    all_cols <- c(all_cols, extra)
  }
  all_cols[acronyms]
}

#' Get ancestry metadata
#'
#' Returns a data.frame with acronyms, full ancestry names, population group
#' abbreviations, and hex colors.
#'
#' @return A data.frame with columns: acronym, ancestry, pop_group, color.
#' @export
#' @examples
#' pgscatalog_ancestry_info()
pgscatalog_ancestry_info <- function() {
  data.frame(
    acronym = .pgscatalog_env$unique_abbrev,
    ancestry = .pgscatalog_env$ancestries,
    pop_group = .pgscatalog_env$pop_abbrev,
    color = unname(.pgscatalog_env$colors),
    stringsAsFactors = FALSE
  )
}
