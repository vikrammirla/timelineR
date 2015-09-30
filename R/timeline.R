#' Interactive Timeline Plots
#'
#' Easily create interactive \code{d3.js} timelines using the
#' \href{https://github.com/emeeks/d3.layout.timeline}{d3.layout.timeline} layout from Elijah Meeks.  Since
#' we leverage the infrastructure of htmlwidgets, these interactive
#' timelines should work seamlessly in all R contexts, including the console,
#' RStudio, rmarkdown, and Shiny.
#' 
#' @param data \code{data.frame} of data to be plotted
#' @param dateFormat function that returns the values for the start and end of the bands. Defaults to function (d) {return new Date(d)}. The timeline layout can plot floats and ints for relative time (see the simple example that uses integer positions for start and end points).
#' @param bandStart function that returns the start of the band. Remember that it will also be passed through timeline.dateFormat. Defaults to function (d) {return d.start}.
#' @param bandEnd function that returns the start of the band. Remember that it will also be passed through timeline.dateFormat. Defaults to function (d) {return d.end}. If you want to use duration-based notation, you might try something like function (d) {return d.start + d.duration}.
#' @param extent extent of the timeline. By default, the extent is set to the minimum start and maximum end, but if you have a range you'd rather set the timeline to, you can do so. This is also passed through #timeline.dateFormat.
#' @param padding distance in pixels between lanes. Defaults to 0.
#' @param maxBandHeight maximum band height. Defaults to Infinity (bands will fill the given height in the timeline.size array minus any necessary padding).
#' @param children children accessor, for use with hierarchical timeline data. Typically children are stored in an array in .children or .values. Set to return null or false to disable hierarchical support. Hierarchical data can be a hierarchical JSON object (like the ubiquitous flare.json dataset) or an array of objects with each having child elements.
#' @param colorScale function to color the timeline bands
#' @param color name of key/variable to color by. See \code{\link{colorScale}}
#' @param width,height a valid \code{CSS} unit for the width and height of the
#'          htmlwidget container
#' 
#' @example ./inst/examples/example_timeline.R
#' @import htmlwidgets
#'
#' @export
timeline <- function(
  data = NULL,
  dateFormat = NULL,
  bandStart = NULL,
  bandEnd = NULL,
  extent = NULL,
  padding = NULL,
  maxBandHeight = NULL,
  children = NULL,
  colorScale = NULL,
  color = NULL,
  width = NULL, height = NULL) {

  # forward options using x
  x = list(
    data = data,
    options = list(
      dateFormat = dateFormat,
      bandStart = bandStart,
      bandEnd = bandEnd,
      extent = extent,
      padding = padding,
      maxBandHeight = maxBandHeight,
      children = children
    ),
    colorScale = colorScale,
    color = color
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'timeline',
    x,
    width = width,
    height = height,
    package = 'timelineR'
  )
}

#' Shiny bindings for timeline
#'
#' Output and render functions for using timeline within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a timeline
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name timeline-shiny
#'
#' @export
timelineOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'timeline', width, height, package = 'timelineR')
}

#' @rdname timeline-shiny
#' @export
renderTimeline <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, timelineOutput, env, quoted = TRUE)
}
