#' Fuzzy-match ancestry labels to PGS Catalog acronyms
#'
#' Attempts to map a character vector of ancestry labels to their PGS Catalog
#' acronyms. Matching proceeds in three steps:
#'
#' 1. **Exact match** against known acronyms (case-insensitive).
#' 2. **Exact match** against full ancestry names (case-insensitive).
#' 3. **Fuzzy match** using edit distance against both acronyms and full names,
#'    accepting the closest match within `max_dist` edits.
#'
#' Unresolved labels (no match within `max_dist`) are returned as `NA` and
#' always trigger a warning.
#'
#' @param labels Character vector of ancestry labels to match. Values may be
#'   acronyms (e.g., `"eur"`, `"Eur"`), full names (e.g.,
#'   `"european"`, `"East_Asian"`), or anything in between.
#' @param max_dist Integer. Maximum edit distance to accept as a fuzzy match.
#'   Lower values are stricter. Default: `3`. Set to `0` to disable fuzzy
#'   matching and accept only exact matches.
#' @param quiet Logical. Suppress warnings about fuzzy matches and failures?
#'   Default: `FALSE`.
#'
#' @return A character vector the same length as `labels` containing PGS Catalog
#'   acronyms, or `NA` where no match was found.
#'
#' @seealso [pgscatalog_ancestry_info()] for the full lookup table.
#'
#' @export
#' @examples
#' pgscatalog_match(c("EUR", "eur", "european", "East Asian", "east_asian"))
#' pgscatalog_match(c("Europeen", "SAS", "unknown_group"), max_dist = 3)
#'
#' # Typical use: add a matched acronym column then plot
#' df <- data.frame(
#'   label = c("European", "african unspecified", "EAST ASIAN", "sas"),
#'   value = c(1.2, 0.8, 1.5, 0.9)
#' )
#' df$acronym <- pgscatalog_match(df$label)
pgscatalog_match <- function(labels, max_dist = 3, quiet = FALSE) {
  info        <- pgscatalog_ancestry_info()
  acronyms    <- info$acronym
  full_names  <- info$ancestry

  # Normalise a string: lowercase, collapse separators to single space
  normalise <- function(x) {
    x <- tolower(trimws(x))
    gsub("[_./ -]+", " ", x)
  }

  norm_acronyms   <- normalise(acronyms)
  norm_full_names <- normalise(full_names)
  norm_labels     <- normalise(labels)

  fuzzy_hits  <- character(length(labels))
  match_types <- character(length(labels))

  for (i in seq_along(norm_labels)) {
    lbl <- norm_labels[i]

    # Step 1: exact match on acronym
    hit <- match(lbl, norm_acronyms)
    if (!is.na(hit)) {
      fuzzy_hits[i]  <- acronyms[hit]
      match_types[i] <- "exact_acronym"
      next
    }

    # Step 2: exact match on full name
    hit <- match(lbl, norm_full_names)
    if (!is.na(hit)) {
      fuzzy_hits[i]  <- acronyms[hit]
      match_types[i] <- "exact_name"
      next
    }

    # Step 3: fuzzy match against both candidate pools
    if (max_dist > 0) {
      candidates <- c(norm_acronyms, norm_full_names)
      dists      <- utils::adist(lbl, candidates, ignore.case = TRUE)[1, ]
      best_dist  <- min(dists)

      if (best_dist <= max_dist) {
        best_idx       <- which.min(dists)
        # Map pool index back to acronym
        fuzzy_hits[i]  <- acronyms[(best_idx - 1) %% length(acronyms) + 1]
        match_types[i] <- "fuzzy"
      } else {
        fuzzy_hits[i]  <- NA_character_
        match_types[i] <- "no_match"
      }
    } else {
      fuzzy_hits[i]  <- NA_character_
      match_types[i] <- "no_match"
    }
  }

  if (!quiet) {
    fuzzy_idx <- which(match_types == "fuzzy")
    if (length(fuzzy_idx) > 0) {
      warning(
        "Fuzzy matches accepted (verify these are correct):\n",
        paste0('  "', labels[fuzzy_idx], '" -> ', fuzzy_hits[fuzzy_idx],
               collapse = "\n"),
        call. = FALSE
      )
    }

    fail_idx <- which(match_types == "no_match")
    if (length(fail_idx) > 0) {
      warning(
        "No match found (returned NA) for:\n",
        paste0('  "', labels[fail_idx], '"', collapse = "\n"),
        "\nCall pgscatalog_ancestry_info() to see valid labels.",
        call. = FALSE
      )
    }
  }

  fuzzy_hits
}
