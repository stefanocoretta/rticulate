#' Data import function.
#'
#' It reads a file with data exported from AAA. The data are automatically
#' transformed from a wide to a long format (each row has values of X or Y axes
#' for each fan line). The imported tibble can then be used for plotting and
#' statistical analysis.
#'
#' @param file The file or files with AAA data.
#' @param column.names The names of the columns withouth including the splines columns.
#' @param fan.lines The number of fan lines.
#' @param coordinates A string specifying the coordinate system. Possible values are \code{"cartesian"} and \code{"polar"}.
#' @param na.rm Remove NAs.
#' @importFrom magrittr "%>%"
#' @keywords internal
read_aaa_data <- function(file, column.names, fan.lines, coordinates, na.rm) {
    if (coordinates == "cartesian") {
        coord.names <- paste0(
            rep(c("X_", "Y_"), fan.lines),
            rep(1:fan.lines, each = 2)
        )
    } else {
        coord.names <- paste0(
            rep(c("radius_", "theta_"), each = fan.lines),
            rep(1:fan.lines)
        )
    }

    columns <- c(
        column.names,
        coord.names
    )

    data <- readr::read_tsv(
        file,
        col_names = columns,
        na = "*",
        trim_ws = TRUE
    ) %>%
        dplyr::mutate_at(dplyr::vars(dplyr::matches("(^[XY]_)|(^radius_)|(^theta_)")),
                         dplyr::funs(as.numeric)) %>%
        tidyr::gather(spline, coordinate,
                      dplyr::matches("(^[XY]_)|(^radius_)|(^theta_)")) %>%
        tidyr::separate(spline, c("axis", "fan"), convert = TRUE) %>%
        tidyr::spread(axis, coordinate)

    if (na.rm == TRUE) {
        data <- stats::na.omit(data)
    }

    return(data)
}

#' Read tab separated files with AAA spline data.
#'
#' It reads a file or a list of files with data exported from AAA. The data are
#' automatically transformed from a wide to a long format (each row has values
#' of X or Y axes for each fan line). The imported tibble can then be used for
#' plotting and statistical analysis.
#'
#' @param file The path of the file with AAA data. It can also be a character vector with multiple paths as separate strings..
#' @param column.names The names of the columns withouth including the splines columns.
#' @param fan.lines The number of fan lines (the default is \code{42}).
#' @param coordinates A string specifying the coordinate system. Possible values are \code{"cartesian"} (the default) and \code{"polar"}.
#' @param na.rm Remove NAs (the default is \code{FALSE}).
#' @export
read_aaa <- function(file, column.names, fan.lines = 42, coordinates = "cartesian", na.rm = FALSE) {
    if(!coordinates %in% c("cartesian", "polar")) {
        stop("The chosen coordinate system is not supported. Possible values are cartesian or polar.")
    }

    if (length(file) == 1) {
        read_aaa_data(file, column.names, fan.lines, coordinates, na.rm)
    } else {
        purrr::map_df(.x = file, .f = ~read_aaa_data(.x, column.names, fan.lines, coordinates, na.rm))
    }
}

#' Plot tongue contours from spline data.
#'
#' It plots tongue contours from data imported from AAA.
#'
#' @param data A data frame with splines data.
#' @param ... List of arguments to be passed to \code{geom}.
#' @param palate An optional data frame with the palate spline. If provided,
#' the palate is plotted.
#' @param palate.col The colour of the palate spline (the default is \code{green}).
#' @export
plot_splines <- function(data, ..., palate = NULL, palate.col = "green") {
    spline.plot <- ggplot2::ggplot(data, ggplot2::aes_(x = ~X, y = ~Y)) +
        ggplot2::geom_line(stat = "smooth", method = "loess", se = FALSE, ...) +
        ggplot2::coord_fixed(ratio = 1) +
        ggplot2::labs(x = "antero-posterior",
             y = "supero-inferior"
        )

    if (is.null(palate) == FALSE) {
        spline.plot <- spline.plot +
            ggplot2::geom_line(stat = "smooth", method = "loess",
                               data = palate, se = F, colour = palate.col
                               )
    }

    return(spline.plot)
}
