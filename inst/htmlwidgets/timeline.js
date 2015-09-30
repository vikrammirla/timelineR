HTMLWidgets.widget({

  name: 'timeline',

  type: 'output',

  initialize: function(el, width, height) {

    return {  }

  },

  renderValue: function(el, x, instance) {

    // remove everything from el in case of dynamic/Shiny
    d3.select(el).selectAll("*").remove();
    
    var svg = d3.select(el).append("svg")
                  .style("width","100%")
                  .style("height", "100%");
                  
    var timeline = d3.layout.timeline()
      .size([
        el.getBoundingClientRect().width,
        el.getBoundingClientRect().height
      ])
      
    // loop through each of our options from R
    //  and if exists in d3.layout.timeline set it
    Object.keys(x.options).forEach(function(ky){
      if(timeline[ky] && x.options[ky] !== null){
        timeline[ky](x.options[ky]);
      }
    })
    
    // set up our colorScale
    //  start with a default fill from the simple integer example
    var colorScale = function(d){ return "#687a97" };
    // then look in our x.colorScale to see if anything provided in R
    if( x.colorScale !== null ){
      colorScale = x.colorScale;
    }
    
    timelineBands = timeline(HTMLWidgets.dataframeToD3(x.data));
    
    svg.selectAll("rect")
      .data(timelineBands)
      .enter()
      .append("rect")
      .attr("x", function (d) {return d.start})
      .attr("y", function (d) {return d.y})
      .attr("height", function (d) {return d.dy})
      .attr("width", function (d) {return d.end - d.start})
      .style("fill", function(d) {return colorScale(d)})
      .style("stroke", "black")
  },

  resize: function(el, width, height, instance) {

  }

});
