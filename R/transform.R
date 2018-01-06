#' Transform the coordinates of spline data
#'
#' It transforms the coordinates of spline data between the cartesian and polar
#' coordinate systems.
#'
#' @param data A data set containing the spline coordinates (cartesian coordinates must be in columns named \code{X} and \code{Y}, polar coordinates in columns named \code{theta} and \code{radius}; these are the defaults in data imported with \code{read_aaa()}).
#' @param to Which system to convert to, as a string, either \code{"polar"} or \code{"cartesian"} (the default is \code{"polar"}).
#' @param origin The coordinates of the origin as a vector of \code{c(x, y)} coordinates.
#' @inheritParams get_origin
#' @export
transform_coord <- function(data, to = "polar", origin = NULL, fan_lines = c(10, 25)) {
    if (!(to %in% c("polar", "cartesian"))) {
        stop("Please, specify either 'polar' or 'cartesian' as the value of 'to'.")
    }

    if (is.null(origin)) {
        origin <- rticulate::get_origin(data, fan_lines = fan_lines)
    }

    if (to == "polar") {
        transformed_data <- data %>%
            dplyr::mutate(
                radius = sqrt((X - origin[1]) ^ 2 + (Y - origin[2]) ^ 2),
                angle = pi + atan2(Y - origin[2], X - origin[1])
            )
    } else {
        transformed_data <- data %>%
            dplyr::mutate(
                X = origin[1] - radius * cos(angle),
                Y = -(radius * sin(angle) - origin[2])
            )
    }

    return(transformed_data)
}

#' Get the origin of spline data
#'
#' It returns the x,y coordinates of the intersection of the fan lines, which correponds to the origin of the ultrasonic waves/probe surface.
#'
#' @param data The spline data (the cartesian coordinates must be in two columns named \code{X} and \code{Y}).
#' @param fan_lines A numberic vector with two fan lines (the default is \code{c(10, 25)}).
#'
#' @export
get_origin <- function(data, fan_lines = c(10, 25)) {
    if (!("X" %in% colnames(data)) || !("Y" %in% colnames(data))) {
        stop(glue::glue("`data` does not contain columns named `X` and/or `Y`. Please, change the column names in `data` or add the columns `X` and `Y` to it."))
    }

    if (!("fan_line" %in% colnames(data))) {
        stop(glue::glue("'{fan_line_col}' is not a column of data. Please, specify the name of the fan line column in your data."))
    }

    if (nrow(data) == 0) {
        stop("Cannot work with empty data. Please, choose non-empty data.")
    }

    line_1 <- dplyr::filter(data, fan_line == fan_lines[1])
    line_2 <- dplyr::filter(data, fan_line == fan_lines[2])

    line_1_model <- stats::lm(
        Y ~ X,
        data = line_1
    )
    line_2_model <- stats::lm(
        Y ~ X,
        data = line_2
    )

    coefficient_matrix <- rbind(stats::coef(line_1_model), stats::coef(line_2_model))
    origin <- c(
        -solve(cbind(coefficient_matrix[,2], -1)) %*% coefficient_matrix[,1]
    )

    if (anyNA(origin)) {
        fan_lines_print <- paste("c(", fan_lines[1], ", ", fan_lines[2], ")", sep = "")
        stop(glue::glue("Could not calculate origin. The chosen fan_lines ({fan_lines_print}) do not contain data. Please, try different fan lines."))
    }

    message(glue::glue("The origin is x = {origin[1]}, y = {origin[2]}."))
    return(origin)
}
