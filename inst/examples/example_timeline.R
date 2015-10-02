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
'd3.scale.ordinal()
    .domain(["European","Native","Colonial","Latin America","Internal"])
    .range(["#96abb1", "#313746", "#b0909d", "#687a97", "#292014"])
'    
  ),
  color = "sphere"
)

# same as above except use d3 built-in color scale
timeline(
  read.csv("http://bl.ocks.org/emeeks/raw/280cb0607c68faf30bb5/wars.csv"),
  colorScale = htmlwidgets::JS('d3.scale.category10()'),
  color = "sphere"
)

\dontrun{
  # quick chart with Alabama crop planting and harvesting dates
  # http://www.nass.usda.gov/Publications/Usual_Planting_and_Harvesting_Dates/uph97.pdf
  
  crop_al <- data.frame(
    crop = c(
      "Corn, for Grain",
      "Cotton",
      #"Hay, Other",
      "Peanuts",
      "Sorghum, for Grain",
      "Sorghum, for Silage",
      "Soybeans",
      "Wheat, Winter"
    ),
    begin = paste0(
      c(
        "March 5",
        "April 12",
        #"",
        "April 16",
        "April 1",
        "April 1",
        "April 30",
        "October 2"
      ),
      ",2015"
    ),
    end = c(
      "November 2, 2015",
      "December 15, 2015",
      #"October 15",
      "November 1, 2015",
      "December 15, 2015",
      "December 15, 2015",
      "December 8, 2015",
      "July 1, 2016"
    ),
    stringsAsFactors = FALSE
  )
  
  crop_al %>>%
    timeline(
      bandStart = htmlwidgets::JS('function(d){return new Date(d.begin)}'),
      bandEnd = htmlwidgets::JS('function(d){return new Date(d.end)}'),
      colorScale = htmlwidgets::JS('d3.scale.category20()'),
      color = "crop"
    ) %>>%
    add_axis(
      tickFormat = htmlwidgets::JS(
        'd3.time.format("%b")'
      )
    )
  
}
