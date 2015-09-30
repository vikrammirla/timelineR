library(timelineR)

# simple example provided by d3.layout.timeline
#   author Elijah Meeks
#   http://bl.ocks.org/emeeks/d24171dac80dd535521b
timeline(
  read.csv("http://bl.ocks.org/emeeks/raw/d24171dac80dd535521b/int_bands.csv"),
  bandStart = htmlwidgets::JS("function (d) {return d.s}"),
  bandEnd = htmlwidgets::JS("function (d) {return d.e}"),
  dateFormat = htmlwidgets::JS("function (d) {return parseInt(d)}")
)


# example with dates provided by d3.layout.timeline author
#  Elijah Meeks
#  http://bl.ocks.org/emeeks/280cb0607c68faf30bb5

timeline(
  read.csv("http://bl.ocks.org/emeeks/raw/280cb0607c68faf30bb5/wars.csv"),
  colorScale = htmlwidgets::JS(
'
function(d){
  var color = d3.scale.ordinal()
    .domain(["European","Native","Colonial","Latin America","Internal"])
    .range(["#96abb1", "#313746", "#b0909d", "#687a97", "#292014"]);
  return color(d.sphere);
}
'    
  )
)
