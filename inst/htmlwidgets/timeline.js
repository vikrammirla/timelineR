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
    
    var width = el.getBoundingClientRect().width;
    var height = el.getBoundingClientRect().height;

    var timeline = d3.layout.timeline()
      .size([width,height]);
      
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
      .style("fill", function(d) {
        return colorScale(
          x.color === null ? null : d[x.color]
        )
      })
      .style("stroke", "black")
      
    // check to see if we should add some axes
    if(x.axes !== null){
      // generally only expect one axis but allow multiple
      x.axes.forEach(function(ax){
        var axisScale = {};
        if(timelineBands[0].originalStart.constructor === Date){
          axisScale = d3.time.scale();
        } else {
          axisScale = d3.scale.linear();
        }
        
        axisScale
          .range([
            d3.min(timelineBands.map(function(d){return d.start})),
            d3.max(timelineBands.map(function(d){return d.end}))
          ])
          .domain([
            d3.min(timelineBands.map(function(d){return d.originalStart})),
            d3.max(timelineBands.map(function(d){return d.originalEnd}))
          ])
        
        var axis = d3.svg.axis();
        axis.scale(axisScale);
        Object.keys(ax).forEach(function(ky){
          if(ax[ky] !== null && axis[ky]){
            axis[ky](ax[ky]);
          }
        })
        
        var axis_g = svg.append("g")
           .attr("class","timeline-axis")
           .attr("transform","translate(0," + height + ")")
           .call(axis);
           
        // some default styles for our axis
        axis_g.selectAll('path, .tick > line')
           .style("fill","none")
           .style("stroke","black")
      })
      
      // fit the svg to the container with the magic viewBox attribute
      svg.attr(
        "viewBox",
        [
          d3.min(
            svg.selectAll('*')[0].map(function(d){
              return d.getBoundingClientRect().left
            })
          ) - svg.node().getBoundingClientRect().left,
          d3.min(
            svg.selectAll('*')[0].map(function(d){
              return d.getBoundingClientRect().top
            })
          ) - svg.node().getBoundingClientRect().top,
          d3.max(
            svg.selectAll('*')[0].map(function(d){
              return d.getBoundingClientRect().right
            })
          ) -
          d3.min(
            svg.selectAll('*')[0].map(function(d){
              return d.getBoundingClientRect().left
            })
          ),
          d3.max(
            svg.selectAll('*')[0].map(function(d){
              return d.getBoundingClientRect().bottom
            })
          ) -
          d3.min(
            svg.selectAll('*')[0].map(function(d){
              return d.getBoundingClientRect().top
            })
          )
        ].join(",")
      );
      
      // set up a container for tasks to perform after completion
      //  one example would be add callbacks for event handling
      //  styling
      if (!(x.tasks === null) ){
        if ( (typeof x.tasks.length === "undefined") ||
         (typeof x.tasks === "function" ) ) {
           // handle a function not enclosed in array
           // should be able to remove once using jsonlite
           x.tasks = [x.tasks];
        }
        x.tasks.map(function(t){
          // for each tasks call the task with el supplied as `this`
          t.call({el:el,chart:timelineBands});
        });
      }
    }
  },

  resize: function(el, width, height, instance) {

  }

});
