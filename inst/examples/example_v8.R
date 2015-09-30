library(V8)

ctx <- new_context()
# get d3
ctx$source(system.file("htmlwidgets/lib/d3/d3.min.js",package="timelineR"))
# get d3.layout.timeline
ctx$source(system.file("htmlwidgets/lib/d3.layout.timeline/d3.layout.timeline.js",package="timelineR"))
# assign the simple example data to data
ctx$assign("data", read.csv("http://bl.ocks.org/emeeks/raw/d24171dac80dd535521b/int_bands.csv"))
# do the layout and get it in R
ctx$eval(
'
var timeline = d3.layout.timeline()
  .size([1000,300])
  .bandStart(function (d) {return d.s})
  .bandEnd(function (d) {return d.e})
  .dateFormat(function (d) {return parseInt(d)})

timelineBands = timeline(data);
'
)
# see if it worked
ctx$get("timelineBands")