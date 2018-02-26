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

#' Plot smooths from a polar \code{gam}
#'
#' It plots the smooths of a polar GAM fitted with \code{polar_gam()}.
#'
#' @export
plot_polar_smooths <- function(model, time_series, comparison, origin = NULL, facet_terms = NULL, conditions = NULL, exclude_random = TRUE, series_length = 100) {
    time_series_q <- dplyr::enquo(time_series)
    comparison_q <- dplyr::enquo(comparison)
    facet_terms_q <- dplyr::enquo(facet_terms)
    if (facet_terms_q == dplyr::quo(NULL)) {
        facet_terms_q <- NULL
    }
    outcome_q <- model$formula[[2]]

    predicted_tbl <- tidymv::get_gam_predictions(model, !!time_series_q, conditions, exclude_random = exclude_random, series_length = series_length)

    if (is.null(origin)) {
        origin <- model$polar_origin
    }

    cartesian_predicted <- predicted_tbl %>%
        transform_coord(
            to = "cartesian",
            origin = origin,
            use_XY = TRUE
        )

    cartesian_ci <- transform_ci(
        predicted_tbl,
        origin = origin
    )

    smooths_plot <- cartesian_predicted %>%
        ggplot2::ggplot(
            ggplot2::aes_string(
                dplyr::quo_name(time_series_q), dplyr::quo_name(outcome_q)
            )
        ) +
        ggplot2::geom_polygon(
            data = cartesian_ci,
            ggplot2::aes_string(
                x = "CI_X",
                y = "CI_Y",
                fill = dplyr::quo_name(comparison_q)
            ),
            alpha = 0.2
        ) +
        ggplot2::geom_path(
            ggplot2::aes_string(
                colour = dplyr::quo_name(comparison_q),
                linetype = dplyr::quo_name(comparison_q)
            )
        ) +
        {if (!is.null(facet_terms_q)) {
            ggplot2::facet_wrap(facet_terms_q)
        }}

    return(smooths_plot)
}
