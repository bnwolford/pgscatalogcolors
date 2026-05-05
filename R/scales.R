#' PGS Catalog color scale for ggplot2
#'
#' Applies PGS Catalog ancestry colors to the colour aesthetic. When your data
#' uses ancestry acronyms as factor levels, this scale automatically maps the
#' correct color to each group.
#'
#' @param palette Character name of palette: "unique" or "population".
#'   Default: "unique".
#' @param discrete Logical; use a discrete scale? Default: TRUE.
#' @param reverse Logical; reverse palette order? Default: FALSE.
#' @param ... Additional arguments passed to [ggplot2::discrete_scale()] or
#'   [ggplot2::scale_color_gradientn()].
#' @return A ggplot2 scale object.
#' @export
#' @examples
#' library(ggplot2)
#' df <- data.frame(
#'   x = rnorm(60),
#'   y = rnorm(60),
#'   ancestry = rep(c("EUR", "AFR", "EAS", "SAS", "HIS", "MID"), each = 10)
#' )
#' ggplot(df, aes(x, y, color = ancestry)) +
#'   geom_point(size = 3) +
#'   scale_color_pgscatalog()
scale_color_pgscatalog <- function(palette = "unique", discrete = TRUE,
                                   reverse = FALSE, ...) {
  if (discrete) {
    ggplot2::scale_color_manual(values = pgscatalog_cols(), ...)
  } else {
    pal <- pgscatalog_pal(palette = palette, reverse = reverse)
    ggplot2::scale_color_gradientn(colours = pal(256), ...)
  }
}

#' @rdname scale_color_pgscatalog
#' @export
scale_colour_pgscatalog <- scale_color_pgscatalog

#' PGS Catalog fill scale for ggplot2
#'
#' Applies PGS Catalog ancestry colors to the fill aesthetic.
#'
#' @inheritParams scale_color_pgscatalog
#' @return A ggplot2 scale object.
#' @export
#' @examples
#' library(ggplot2)
#' df <- data.frame(
#'   ancestry = c("EUR", "AFR", "EAS", "SAS", "HIS", "MID"),
#'   count = c(50, 20, 15, 10, 8, 5)
#' )
#' ggplot(df, aes(ancestry, count, fill = ancestry)) +
#'   geom_col() +
#'   scale_fill_pgscatalog()
scale_fill_pgscatalog <- function(palette = "unique", discrete = TRUE,
                                  reverse = FALSE, ...) {
  if (discrete) {
    ggplot2::scale_fill_manual(values = pgscatalog_cols(), ...)
  } else {
    pal <- pgscatalog_pal(palette = palette, reverse = reverse)
    ggplot2::scale_fill_gradientn(colours = pal(256), ...)
  }
}
