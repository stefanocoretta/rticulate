#' Plot tongue contours from spline data.
#'
#' It plots tongue contours from data imported from AAA.
#'
#' @param data A data frame with splines data.
#' @param geom Type of geom to plot. Possible values are: \code{line} (the default),
#' \code{point}, \code{path}.
#' @param ... List of arguments to be passed to \code{geom}.
#' @param palate An optional data frame with the palate spline. If provided,
#' the palate is plotted.
#' @param palate_col The colour of the palate spline (the default is \code{green}).
#' @export
plot_tongue <- function(data, geom = "line", ..., palate = NULL, palate_col = "green") {
    spline_plot <- ggplot2::ggplot(data, ggplot2::aes_(x = ~X, y = ~Y)) +
    {if (geom == "line") {
        ggplot2::geom_line(stat = "smooth", method = "loess", se = FALSE, ...)
    } else if (geom == "point") {
        ggplot2::geom_point(...)
    } else if (geom == "path") {
        ggplot2::geom_path(...)
    }} +
        ggplot2::coord_fixed(ratio = 1) +
        ggplot2::labs(x = "antero-posterior",
                      y = "supero-inferior"
        )

    if (is.null(palate) == FALSE) {
        spline_plot <- spline_plot +
            ggplot2::geom_line(stat = "smooth", method = "loess",
                               data = palate, se = F, colour = palate_col
            )
    }

    return(spline_plot)
}
