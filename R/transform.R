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

get_origin <- function(data) {

}
