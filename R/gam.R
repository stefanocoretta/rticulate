#' Polar generalised additive model (polar GAM)
#' @export
polar_gam <- function(formula, data, origin = NULL, fan_lines = c(10, 25), ...) {
    if (is.null(origin)) {
        origin <- rticulate::get_origin(data, fan_lines = fan_lines)
    }

    polar_data <- data %>%
        rticulate::transform_coord(., to = "polar", origin = origin, use_XY = TRUE)

    model <- mgcv::bam(formula = formula, data = polar_data, ...)

    model$polar_origin <- origin

    return(model)
}
