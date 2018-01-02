#' Transform the coordinates of spline data
#'
#' It transforms the coordinates of spline data between the cartesian and polar
#' coordinate systems.
#'
#' @param data A data set containing the spline coordinates.
#' @param to Which system to convert to, as a string, either \code{"polar"} or \code{"cartesian"} (the default is \code{"polar"}).
#' @param origin The coordinates of the origin as a vector of \code{c(x, y)} coordinates.
#' @export
transform_coordinates <- function(data, to = "polar", origin = NULL) {
    if (is.null(origin)) {
        origin <- rticulate::get_origin(data)
    }
}

get_origin <- function(data, fan_line_col = "fan_line", fan_lines = c(10, 25)) {
    x_1 <- c(
        data$X[data[[fan_line_col]] == fan_lines[1]][1],
        data$X[data[[fan_line_col]] == fan_lines[1]][2]
    )
    y_1 <- c(
        data$Y[data[[fan_line_col]] == fan_lines[1]][1],
        data$Y[data[[fan_line_col]] == fan_lines[1]][2]
    )

    x_2 <- c(
        data$X[data[[fan_line_col]] == fan_lines[2]][1],
        data$X[data[[fan_line_col]] == fan_lines[2]][2]
    )
    y_2 <- c(
        data$Y[data[[fan_line_col]] == fan_lines[2]][1],
        data$Y[data[[fan_line_col]] == fan_lines[2]][2]
    )

    denominator <- ((x_1[1] - x_1[2]) * (y_2[1] - y_2[2]) - (y_1[1] - y_1[2]) * (x_2[1] - x_2[2]))

    x <- ((x_1[1]*y_1[2] - y_1[1]*x_1[2]) * (x_2[1] - x_2[2]) - (x_1[1] - x_1[2]) * (x_2[1] * y_2[2] - y_2[1] * x_2[2])) / denominator

    y <- ((x_1[1]*y_1[2] - y_1[1]*x_1[2]) * (y_2[1] - y_2[2]) - (y_1[1] - y_1[2]) * (x_2[1] * y_2[2] - y_2[1] * x_2[2])) / denominator

    return(c(x, y))
}
