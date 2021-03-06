% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transform.R
\name{get_origin}
\alias{get_origin}
\title{Get the origin of spline data}
\usage{
get_origin(data, fan_lines = c(10, 25))
}
\arguments{
\item{data}{The spline data (the cartesian coordinates must be in two columns
named \code{X} and \code{Y}).}

\item{fan_lines}{A numeric vector with two fan lines (the default is
\code{c(10, 25)}).}
}
\value{
A numeric vector with the Cartesian \code{(x, y)} coordinates of the virtual origin of the
  ultrasonic waves/probe surface.
}
\description{
It returns the Cartesian \code{x, y} coordinates of the virtual origin of the
ultrasonic waves/probe surface (see Details).
}
\details{
The function estimates the origin of the ultrasond waves from the probe using
the spline data and the provided fan lines. The estimation method is based on
Heyne, Matthias & Donald Derrick (2015) Using a radial ultrasound probe's
virtual origin to compute midsagittal smoothing splines in polar coordinates.
\emph{The Journal of the Acoustical Society of America} 138(6), EL509–EL514,
DOI:10.1121/1.4937168.
}
\section{Origin estimation}{
 The equations of the two fan lines (10 and 25 by
  default) are set equal to find their intersection. The intersection is the
  origin. In some cases, the linear estimation of the equation fails, and an
  error related to fit is returned. In these cases, try different fan lines
  by increasing the minimum fan line and/or changing the maximum fan line
  (for example, if \code{c(10, 25)} returns an error, try \code{c(15, 30)}).
}

