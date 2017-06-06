#' Read data exported from AAA
#'
#' It reads a file with data exported from AAA. The data are automatically
#' transformed from a wide to a long format (each row has values of X or Y axes
#' for each fan line). The imported tibble can then be used for plotting and
#' statistical analysis.
#'
#' @param file A character vector.
#' @param column.names A character vector with the names of the columns.
#' @param fan.lines A number vector with the number of fan lines (the default is 42).
#' @param na.rm A boolean string (the default is `FALSE`).
#' @importFrom magrittr "%>%"
read_aaa <- function(file, column.names, fan.lines = 42, na.rm = FALSE) {
    columns <- c(
        column.names,
        paste0(rep(c("X", "Y"), fan.lines),
               "_",
               rep(1:fan.lines, each = 2)
        )
    )

    data <- readr::read_tsv(
        file,
        col_names = columns,
        na = "*",
        trim_ws = TRUE
    ) %>%
        dplyr::mutate_at(dplyr::vars(dplyr::matches("^[XY]_")), dplyr::funs(as.numeric)) %>%
        tidyr::gather(spline, coordinate, dplyr::matches("[XY]_")) %>%
        tidyr::separate(spline, c("axis", "fan"), convert = TRUE) %>%
        tidyr::spread(axis, coordinate)

    if (na.rm == TRUE) {
        data <- na.omit(data)
    }

    return(data)
}

#' Plot tongue contours from spline data.
#'
#' It plots tongue contours from data imported from AAA.
#'
#' @param data A data frame.
plot_splines <- function(data) {
    ggplot2::ggplot(data, aes(X, Y)) +
        geom_smooth(method = "loess", se = FALSE) +
        coord_fixed(ratio = 1) +
        labs(x = "antero-posterior",
             y = "supero-inferior"
        )
}
