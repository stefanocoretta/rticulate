#' Read data exported from AAA
#'
#' It reads a file with data exported from AAA.
#'
#' @param file A character vector.
#' @param column.names A character vector with the names of the columns.
#' @param fan.lines A number vector with the number of fan lines (the default is 42).
#' @param na.rm A boolean string (the default is `FALSE`).
read_aaa <- function(file, column.names, fan.lines = 42, na.rm = FALSE) {
    columns <- c(
        column.names,
        paste0(rep(c("X", "Y"), fan.lines),
               "_",
               rep(1:fan.lines, each = 2)
        )
    )

    data <- read_tsv(
        file,
        col_names = columns,
        na = "*",
        trim_ws = TRUE
    ) %>%
        mutate_at(vars(matches("^[XY]_")),funs(as.numeric)) %>%
        gather(spline, coordinate, matches("[XY]_")) %>%
        separate(spline, c("axis", "fan"), convert = TRUE) %>%
        spread(axis, coordinate)

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
    ggplot(data, aes(X, Y)) +
        geom_smooth(method = "loess", se = FALSE) +
        coord_fixed(ratio = 1) +
        labs(x = "antero-posterior",
             y = "supero-inferior"
        )
}
