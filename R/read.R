#' Data import function.
#'
#' It reads a file with data exported from AAA. The data are automatically
#' transformed from a wide to a long format (each row has values of X or Y axes
#' for each fan line). The imported tibble can then be used for plotting and
#' statistical analysis.
#'
#' @param file The file or files with AAA data.
#' @param knots The number of spline knots.
#' @param coordinates A string specifying the coordinate system. Possible values are \code{"cartesian"} and \code{"polar"}.
#' @param na_rm Remove NAs.
#' @param format A string specifying the data format. Possible values are \code{"long"} and \code{"wide"} (the default is \code{"long"}).
#' @param column_names The names of the columns without including the splines columns.
#'
#' @return An object of class \code{\link[tibble]{tbl_df-class}} (a tibble).
#'
#' @importFrom magrittr "%>%"
#' @keywords internal
read_aaa_data <- function(
    file,
    coordinates = "cartesian",
    format = "long",
    na_rm = TRUE,
    knots = NULL,
    column_names = NULL) {
  if (is.null(column_names)) {
    aaa_data <- readr::read_tsv(file, na = "*", trim_ws = TRUE)

    if (sum(stringr::str_detect(colnames(aaa_data), "^[XY]\\d+\\s")) == 0) {
      stop("Column header not detected. Please provide column names for all columns except the X/Y coordinates columns.")
    }
  } else {
    if (coordinates == "cartesian") {
        coord_names <- paste0(
            rep(c("X", "Y"), knots),
            rep(1:knots, each = 2),
            " NA"
        )
    } else {
        coord_names <- paste0(
            rep(c("radius", "theta"), each = knots),
            rep(1:knots),
            " NA"
        )
    }

    columns <- c(
        column_names,
        coord_names
    )

    aaa_data <- readr::read_tsv(file, na = "*", trim_ws = TRUE, col_names = columns)
  }

    if (format == "long") {
      aaa_data <- aaa_data |>
            # Add index column for cases where contours don't have an identifier
            dplyr::mutate(
                frame_id = dplyr::row_number(),
                dplyr::across(
                  dplyr::matches("(^[XY]\\d+\\s)|(^radius_)|(^theta_)"),
                  as.numeric
                )
            ) |>
            tidyr::pivot_longer(
                cols = dplyr::matches("(^[XY]\\d+\\s)|(^radius_)|(^theta_)"),
                names_sep = "\\s",
                names_to = c("coord_knot", "spline"),
                values_to = "value"
            ) |>
        tidyr::separate_wider_position(coord_knot, c(coord = 1, knot = 2), too_few = "align_start") |>
        dplyr::mutate(knot = as.numeric(knot)) |>
        tidyr::pivot_wider(names_from = coord, values_from = value) |>
        dplyr::relocate(frame_id, .after = tidyselect::last_col())

      if ("Date Time of recording" %in% colnames(aaa_data)) {
        aaa_data <- aaa_data |>
          dplyr::mutate(
            displ_id = as.numeric(
              as.factor(
                paste0(`Date Time of recording`, spline, sprintf("%02d", knot))))
          )
      } else {
        cli::cli_alert_warning(
          "Column `Date Time of recording` not found. Did not create a `displ_id` column.
          We recommend to include `Date Time of recording` when exporting data from AAA."
        )
      }
    } else if (format == "wide") {
        aaa_data <- aaa_data |>
        dplyr::mutate(
          frame_id = dplyr::row_number(),
          dplyr::across(
            dplyr::matches("(^[XY]\\d+\\s)|(^radius_)|(^theta_)"),
            as.numeric
          )
        )
    } else {
        stop("Format not recognised. Available formats are 'long' and 'wide'.")
    }

    if (na_rm == TRUE) {
      tidyr::drop_na(aaa_data)
    }

    return(aaa_data)
}

#' Read tab separated files with AAA spline data.
#'
#' It reads a file or a list of files with data exported from AAA. The data are
#' automatically transformed from a wide to a long format (each row has values
#' of X or Y axes for each fan line). The imported tibble can then be used for
#' plotting and statistical analysis.
#'
#' @param file The path of the file with AAA data. It can also be a character vector with multiple paths as separate strings..
#' @param coordinates A string specifying the coordinate system. Possible values are \code{"cartesian"} (the default) and \code{"polar"}.
#' @param format A string specifying the data format. Possible values are \code{"long"} and \code{"wide"} (the default is \code{"long"}).
#' @param na_rm Remove NAs (the default is \code{FALSE}).
#' @param knots The number of spline knots or fan lines.
#' @param column_names The names of the columns without including the splines columns.
#'
#' @return A tibble.
#'
#' @examples
#' columns <- c("speaker","seconds","rec_date","prompt","label",
#' "TT_displacement","TT_velocity","TT_abs_velocity","TD_displacement",
#' "TD_velocity","TD_abs_velocity")
#' file_path <- system.file("extdata", "it01.tsv", package = "rticulate")
#'
#' tongue <- read_aaa(file_path, knots = 42, column_names = columns)
#'
#' @export
read_aaa <- function(file, coordinates = "cartesian", format = "long", na_rm = FALSE, knots = NULL, column_names = NULL) {
    if (!coordinates %in% c("cartesian", "polar")) {
        stop("The chosen coordinate system is not supported. Possible values are cartesian or polar.")
    }

    if (length(file) == 1) {
        read_aaa_data(file, coordinates = coordinates, format = format, na_rm = na_rm, knots = knots, column_names = column_names)
    } else {
        purrr::map_df(.x = file, .f = ~read_aaa_data(.x, coordinates = coordinates, format = format, na_rm = na_rm, knots = knots, column_names = column_names))
    }
}
