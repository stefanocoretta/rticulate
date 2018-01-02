#' Transform the coordinates of spline data
#'
#' It transforms the coordinates of spline data between the cartesian and polar
#' coordinate systems.
#'
#' @param data A data set containing the spline coordinates.
#' @param to Which system to convert to, as a string, either \code{"polar"} or \code{"cartesian"} (the default is \code{"polar"}).
#' @param origin The coordinates of the origin as a vector of \code{c(x, y)} coordinates.
#' @export
transform_coord <- function(data, to = "polar", origin = NULL) {
    if (is.null(origin)) {
        origin <- rticulate::get_origin(data)
    }
}

#' Get the origin of spline data
#'
#' It returns the x,y coordinates of the intersection of the fan lines, which correponds to the origin of the ultrasonic waves/probe surface.
#'
#' @param data The spline data (the cartesian coordinates must be in two columns named \code{X} and \code{Y}).
#' @param fan_line_col A string with the name of the column listing the fan line numbers (the default is \code{"fan_line"}, which is the default for data imported with \code{read_aaa()}).
#' @param fan_lines A numberic vector with two fan lines (the default is \code{c(10, 25)}).
#'
#' @export
get_origin <- function(data, fan_line_col = "fan_line", fan_lines = c(10, 25)) {
    line_1_model <- lm(
        Y ~ X,
        data = dplyr::filter(data, fan_line == fan_lines[1])
    )
    line_2_model <- lm(
        Y ~ X,
        data = dplyr::filter(data, fan_line == fan_lines[2])
    )

    coefficient_matrix <- rbind(coef(line_1_model), coef(line_2_model))
    origin <- c(
        -solve(cbind(coefficient_matrix[,2], -1)) %*% coefficient_matrix[,1]
    )

    return(origin)
}
