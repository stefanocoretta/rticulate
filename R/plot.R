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
#'
#' @return An object of class \code{\link[ggplot2]{ggplot}}.
#'
#' @examples
#' plot_tongue(tongue, geom = "point")
#'
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
#' @param split Columns to separate as a named list.
#' @param sep Separator between columns (default is \code{"\\."}, which is the default with \code{}). If character, it is interpreted as a regular expression.
#'
#' @return An object of class \code{\link[ggplot2]{ggplot}}.
#'
#' @name plot_polar_smooths-deprecated
#' @seealso \code{\link{rticulate-deprecated}}
#' @keywords internal
NULL

#' @rdname rticulate-deprecated
#' @export
plot_polar_smooths <- function(model, series, comparison = NULL, origin = NULL, facet_terms = NULL, conditions = NULL, exclude_random = TRUE, series_length = 100, split = NULL, sep = "\\.", time_series) {
  .Deprecated('vignette("polar-gam", package = "rticulate")', msg = "'plot_polar_smooths()' has been deprecated.")
}

#' Polar confidence intervals.
#'
#' It provides a `geom` for plotting polar confidence intervals from the output of \link[rticulate]{predict_polar_gam} with the argument \code{return_ci = true}.
#'
#' @param data A tibble which is the output of \link[rticulate]{predict_polar_gam} with the argument \code{return_ci = true}.
#' @param group The optional grouping factor.
#' @param ci_z The z-value for calculating the CIs (the default is \code{1.96} for 95 percent CI).
#' @param ci_alpha Transparency value of CIs (the default is \code{0.1}).
#'
#' @name geom_polar_ci-deprecated
#' @usage geom_polar_ci(data, group, ci_z, ci_alpha)
#' @seealso \code{\link{rticulate-deprecated}}
#' @keywords internal
NULL

#' @rdname rticulate-deprecated
#' @section \code{geom_polar_ci()}:
#' For \code{geom_polar_ci()}, see \code{vignette("polar-gams", package = "rticulate")}.
#'
#' @export
geom_polar_ci <- function(data, group = NULL, ci_z = 1.96, ci_alpha = 0.1) {
  .Deprecated('vignette("polar-gam", package = "rticulate")', msg = "'geom_polar_ci()' has been deprecated. Check the vignette 'polar-gam' for a working alternative.")
  group_q <- rlang::enquo(group)

  if (rlang::quo_is_null(group_q)) {
    group_q <- NULL
  }

  if (is.null(group_q)) {
    ggplot2::geom_polygon(
      data = data,
      ggplot2::aes(
        x = CI_X,
        y = CI_Y
      ),
      alpha = ci_alpha
    )
  } else {
    ggplot2::geom_polygon(
      data = data,
      ggplot2::aes(
        x = CI_X,
        y = CI_Y,
        group = !!group_q
      ),
      alpha = ci_alpha
    )
  }
}
