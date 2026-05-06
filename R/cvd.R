#' Simulate and assess color vision deficiency for the PGS Catalog palette
#'
#' Simulates how the palette appears under three types of color vision
#' deficiency (CVD) and returns pairs of ancestry groups that fall below a
#' perceptual distance threshold (CIEDE2000 delta-E). Requires the
#' \pkg{colorspace} and \pkg{farver} packages.
#'
#' @details
#' Delta-E (CIEDE2000) thresholds used here:
#' \describe{
#'   \item{< 2.3}{Just-noticeable difference — colors are perceptually
#'     identical under that CVD type.}
#'   \item{2.3 – 10}{Difficult to distinguish, especially in small plot
#'     elements such as points or thin lines.}
#'   \item{10 – 20}{Potentially confusable; use additional encodings (shape,
#'     label) when these pairs appear together.}
#' }
#'
#' **Known problematic pairs** identified from the PGS Catalog palette:
#' \itemize{
#'   \item \strong{Deuteranopia} (red-green; affects ~8\% of males):
#'     ASN/HIS (delta-E 1.7 — nearly identical),
#'     EUR/SAS (4.0), MID/MIE (5.4), NON/MIE (7.9).
#'   \item \strong{Protanopia} (red-green):
#'     ASN/HIS (5.5), EAS/MEE (6.0), MID/NON (6.1), EUR/SAS (10.5).
#'   \item \strong{Tritanopia} (blue-yellow; rare):
#'     ABO/NON (9.8), ASN/HIS (7.7), MIE/MEE (8.9).
#'   \item \strong{Normal vision}:
#'     ABO/NON (9.8 — both grey), ASN/HIS (12.5).
#' }
#'
#' When plotting groups that include these pairs, consider supplementing colour
#' with a second encoding: point shape, direct labels, or hatching.
#'
#' @param threshold Numeric. CIEDE2000 delta-E below which a pair is flagged.
#'   Default: 20. Use 10 for a stricter audit.
#'
#' @return A data frame with columns \code{cvd_type}, \code{acronym1},
#'   \code{acronym2}, \code{color1}, \code{color2}, \code{color1_sim},
#'   \code{color2_sim}, and \code{delta_e}, sorted by delta-E ascending.
#'   Returns invisibly; print it to inspect.
#'
#' @export
#' @examples
#' \donttest{
#'   # requires colorspace and farver
#'   pgscatalog_cvd()
#'   pgscatalog_cvd(threshold = 10)  # stricter: only severe conflicts
#' }
pgscatalog_cvd <- function(threshold = 20) {
  if (!requireNamespace("colorspace", quietly = TRUE)) {
    stop("Package 'colorspace' is required. Install with: install.packages('colorspace')")
  }
  if (!requireNamespace("farver", quietly = TRUE)) {
    stop("Package 'farver' is required. Install with: install.packages('farver')")
  }

  cols <- pgscatalog_cols()
  unique_cols <- cols[!duplicated(cols)]

  cvd_types <- list(
    deuteranopia = colorspace::deutanomaly_cvd[["10"]],
    protanopia   = colorspace::protanomaly_cvd[["10"]],
    tritanopia   = colorspace::tritanomaly_cvd[["10"]]
  )

  hex_to_lab <- function(hex_vec) {
    rgb_mat <- t(grDevices::col2rgb(hex_vec))
    farver::convert_colour(rgb_mat, "rgb", "lab")
  }

  results <- lapply(names(cvd_types), function(cvd_name) {
    sim   <- colorspace::simulate_cvd(unique_cols, cvd_types[[cvd_name]])
    nms   <- names(sim)
    n     <- length(sim)
    lab   <- hex_to_lab(sim)
    dists <- farver::compare_colour(lab, lab, from_space = "lab",
                                    method = "cie2000")
    rows <- list()
    for (i in seq_len(n - 1)) {
      for (j in (i + 1):n) {
        d <- dists[i, j]
        if (d < threshold) {
          rows[[length(rows) + 1]] <- data.frame(
            cvd_type  = cvd_name,
            acronym1  = nms[i],
            acronym2  = nms[j],
            color1    = unname(unique_cols[i]),
            color2    = unname(unique_cols[j]),
            color1_sim = unname(sim[i]),
            color2_sim = unname(sim[j]),
            delta_e   = round(d, 1),
            stringsAsFactors = FALSE
          )
        }
      }
    }
    if (length(rows)) do.call(rbind, rows) else NULL
  })

  out <- do.call(rbind, Filter(Negate(is.null), results))
  if (is.null(out) || nrow(out) == 0) {
    message("No pairs below delta-E ", threshold, " found.")
    return(invisible(data.frame()))
  }
  out <- out[order(out$delta_e), ]
  rownames(out) <- NULL
  invisible(out)
}
