#' Add an axis to a timeline plot
#'
#' Often, a timeline plot needs an x axis, so this little function supplies a very thin
#' wrapper for \href{https://github.com/mbostock/d3/wiki/SVG-Axes}{d3.svg.axis}, so that
#' we can add it to our timeline htmlwidget.
#' 
#' @param chart timeline plot htmlwidget to which you would like to add an axis
#' @param scale 
#' @param orient 
#' @param ticks 
#' @param tickValues 
#' @param tickSize 
#' @param innerTickSize 
#' @param outerTickSize 
#' @param tickPadding
#' @param styles 
#'
#' @return timeline chart modified with an added axis
#' @export
#'
add_axis <- function(
  chart = NULL,
  scale = NULL,
  orient = NULL,
  ticks = NULL,
  tickValues = NULL,
  tickSize = NULL,
  innerTickSize = NULL,
  outerTickSize = NULL,
  tickPadding = NULL,
  tickFormat = NULL,
  styles = NULL
){
  
  if(is.null(chart)){
    stop("please provide a chart, so we can add an axis", call. = FALSE)
  }
  if(!inherits(chart,"timeline")) {
    stop("expecting a timeline plot, so we can properly add an axis" , call. = FALSE)
  }
  
  # if chart does not have axes yet then we need to start with an empty list
  if(!is.null(chart$x$axes)) chart$x$axes = list()
  
  chart$x$axes[[length(chart$x$axes) + 1]] <- list(
    scale = scale,
    orient = orient,
    ticks = ticks,
    tickValues = tickValues,
    tickSize = tickSize,
    innerTickSize = innerTickSize,
    outerTickSize = outerTickSize,
    tickPadding = tickPadding,
    tickFormat = tickFormat,
    styles = styles
  )
  
  chart
}

#' Add post-render JavaScript tasks to timeline
#'
#' @param chart timeline plot htmlwidget
#' @param task either a \code{character} or \code{\link[htmlwidgets]{JS}}
#'          representing a JavaScript function to run after a timeline has
#'          been rendered.  This provides the ability for advanced customization.
#'          The JavaScript function will be \code{call}ed so \code{this.el} will be
#'          the containing \code{div} element and \code{this.chart} will be the
#'          \code{timeline} object.
#'
#' @export

add_tasks <- function ( chart, task = NULL ){
  if(is.null(task)) stop("please provide a non-NULL task.", call. = FALSE)
  
  if(is.null(chart$x$tasks)){
    chart$x$tasks <- list()
  }
  
  if(!inherits(task,"JS_EVAL")){
    # convert to htmlwidgets::JS if just a character
    task <- htmlwidgets::JS( task )
  }
  
  chart$x$tasks[[length(chart$x$tasks) + 1]] <- task
  
  chart
}