# pgscatalogcolors

An R package providing color palettes for [PGS Catalog](https://www.pgscatalog.org/) ancestry groups. Each ancestry acronym is mapped to its official PGS Catalog color, enabling consistent and reproducible visualizations of genetic ancestry data.

## Installation

```r
remotes::install_github("bnwolford/pgscatalogcolors")
```

## What your data needs

Your data frame needs a column whose values correspond to **PGS Catalog ancestry acronyms**. The scale functions match the acronyms exactly and case-sensitively, but if your labels are messy (typos, inconsistent capitalisation, full names), use `pgscatalog_match()` first to convert them — see [Fuzzy matching](#fuzzy-matching-messy-labels) below. Call `pgscatalog_ancestry_info()` to see the full lookup table:

```r
library(pgscatalogcolors)
pgscatalog_ancestry_info()
#>    acronym                              ancestry pop_group   color
#> 1      ABO               Aboriginal Australian       DIV #999999
#> 2      AAM  African American or Afro-Caribbean       AFR #F9DA49
#> 3      AFR                 African unspecified       AFR #F9DA49
#> 4      ASN                   Asian unspecified       ASN #B25928
#> 5      CAS                       Central Asian       ASN #B25928
#> 6      EAS                          East Asian       EAS #68AD57
#> 7      EUR                          European        EUR #377EB8
#> 8      MID              Greater Middle Eastern       MID #5DCBCF
#> 9      HIS          Hispanic or Latin American       HIS #D1352B
#> 10     AMR                   Native American        DIV #999999
#> 11     NON                      Not Reported        NON #BBBBBB
#> 12     OCE                         Oceanian        DIV #999999
#> 13     OTH                            Other        DIV #999999
#> 14     ADA            Other admixed ancestry        DIV #999999
#> 15     SAS                       South Asian        SAS #984EA4
#> 16     SEA                   South East Asian       ASN #B25928
#> 17     SAF                 Sub-Saharan African       AFR #F9DA49
#> 18     MIE     Multi-Ancestry including Europeans     MIE #E887BD
#> 19     MEE     Multi-Ancestry excluding Europeans     MEE #EF8632
```

The scale functions match values exactly and case-sensitively against the `acronym` column. The column can have any name. If your data uses full names, abbreviations with typos, or inconsistent formatting, pass the column through `pgscatalog_match()` first.

```r
# Minimal example
df <- data.frame(
  sample_id = paste0("s", 1:4),
  PC1       = rnorm(4),
  PC2       = rnorm(4),
  ancestry  = c("EUR", "AFR", "EAS", "SAS")  # <-- must match acronyms
)
```

## Usage

### ggplot2 color and fill scales

```r
library(ggplot2)

# Scatter plot (color aesthetic)
ggplot(df, aes(PC1, PC2, color = ancestry)) +
  geom_point(size = 3) +
  scale_color_pgscatalog() +
  theme_classic()

# Bar chart (fill aesthetic)
ggplot(counts, aes(ancestry, n, fill = ancestry)) +
  geom_col() +
  scale_fill_pgscatalog() +
  theme_classic()
```

### Manual scale with custom labels

```r
ggplot(df, aes(PC1, PC2, color = ancestry)) +
  geom_point() +
  scale_color_manual(
    values = pgscatalog_scale_values(c("EUR", "AFR", "EAS", "SAS")),
    labels = c(EUR = "European", AFR = "African",
               EAS = "East Asian", SAS = "South Asian")
  )
```

### Look up colors directly

```r
pgscatalog_cols("EUR", "AFR", "EAS")
#>       EUR       AFR       EAS
#> "#377EB8" "#F9DA49" "#68AD57"
```

### Fuzzy-match messy ancestry labels

If your labels have typos, inconsistent capitalisation, or use underscores/hyphens as separators, `pgscatalog_match()` will resolve them to acronyms automatically. It tries exact acronym match, then exact full-name match, then edit-distance fuzzy matching.

```r
pgscatalog_match(c("EUR", "eur", "european", "East Asian", "east_asian"))
#> [1] "EUR" "EUR" "EUR" "EAS" "EAS"

pgscatalog_match(c("Europeen", "Sub-Saharan African", "sas"))
#> Warning: Fuzzy matches accepted (verify these are correct):
#>   "Europeen" -> EUR
#> [1] "EUR" "SAF" "SAS"
```

Typical workflow — clean the column once, then plot:

```r
df$acronym <- pgscatalog_match(df$ancestry_raw)

ggplot(df, aes(OR, ancestry, color = acronym)) +
  geom_point() +
  scale_color_pgscatalog()
```

Labels with no match within `max_dist` edits (default 3) return `NA` with a warning.

### Convert full ancestry names to acronyms

If your labels are exact full names (e.g., "European"), `pgscatalog_match()` handles this directly. For a manual join:

```r
info <- pgscatalog_ancestry_info()
merged <- merge(your_df, info[, c("ancestry", "acronym")],
                by.x = "ancestry_long_col", by.y = "ancestry")
```

## Available acronyms

| Acronym | Ancestry | Color |
|---------|----------|-------|
| ABO | Aboriginal Australian | ![#999999](https://placehold.co/15x15/999999/999999.png) `#999999` |
| AAM | African American or Afro-Caribbean | ![#F9DA49](https://placehold.co/15x15/F9DA49/F9DA49.png) `#F9DA49` |
| AFR | African unspecified | ![#F9DA49](https://placehold.co/15x15/F9DA49/F9DA49.png) `#F9DA49` |
| ASN | Asian unspecified | ![#B25928](https://placehold.co/15x15/B25928/B25928.png) `#B25928` |
| CAS | Central Asian | ![#B25928](https://placehold.co/15x15/B25928/B25928.png) `#B25928` |
| EAS | East Asian | ![#68AD57](https://placehold.co/15x15/68AD57/68AD57.png) `#68AD57` |
| EUR | European | ![#377EB8](https://placehold.co/15x15/377EB8/377EB8.png) `#377EB8` |
| MID | Greater Middle Eastern | ![#5DCBCF](https://placehold.co/15x15/5DCBCF/5DCBCF.png) `#5DCBCF` |
| HIS | Hispanic or Latin American | ![#D1352B](https://placehold.co/15x15/D1352B/D1352B.png) `#D1352B` |
| AMR | Native American | ![#999999](https://placehold.co/15x15/999999/999999.png) `#999999` |
| NON | Not Reported | ![#BBBBBB](https://placehold.co/15x15/BBBBBB/BBBBBB.png) `#BBBBBB` |
| OCE | Oceanian | ![#999999](https://placehold.co/15x15/999999/999999.png) `#999999` |
| OTH | Other | ![#999999](https://placehold.co/15x15/999999/999999.png) `#999999` |
| ADA | Other admixed ancestry | ![#999999](https://placehold.co/15x15/999999/999999.png) `#999999` |
| SAS | South Asian | ![#984EA4](https://placehold.co/15x15/984EA4/984EA4.png) `#984EA4` |
| SEA | South East Asian | ![#B25928](https://placehold.co/15x15/B25928/B25928.png) `#B25928` |
| SAF | Sub-Saharan African | ![#F9DA49](https://placehold.co/15x15/F9DA49/F9DA49.png) `#F9DA49` |
| MIE | Multi-Ancestry including Europeans | ![#E887BD](https://placehold.co/15x15/E887BD/E887BD.png) `#E887BD` |
| MEE | Multi-Ancestry excluding Europeans | ![#EF8632](https://placehold.co/15x15/EF8632/EF8632.png) `#EF8632` |

## License

GPL-3 © Brooke N. Wolford
