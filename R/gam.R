#' Polar generalised additive model (polar GAM)
#'
#' It fits a generalised additive model (GAM) to transformed polar tongue data
#' and it returns a model in polar coordinates. Use \code{plot_polar_smooths()}
#' for plotting.
#'
#' @param formula A GAM formula.
#' @inheritParams transform_coord
#' @param ... Arguments to be passed to \code{mgcv::bam()}.
#'
#' @export
polar_gam <- function(formula, data, origin = NULL, fan_lines = c(10, 25), ...) {
    if (is.null(origin)) {
        origin <- rticulate::get_origin(data, fan_lines = fan_lines)
    }

    polar_data <- rticulate::transform_coord(
        data,
        to = "polar",
        origin = origin,
        use_XY = TRUE
    )

    model <- mgcv::bam(formula = formula, data = polar_data, ...)

    model$polar_origin <- origin

    return(model)
}
