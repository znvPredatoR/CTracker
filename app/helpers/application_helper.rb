module ApplicationHelper

  def line_chart_obj(x_axis_data, y_axis_data)
    {
        labels: x_axis_data,
        datasets: [{
                       fillColor: "rgba(151,187,205,0.5)",
                       strokeColor: "rgba(151,187,205,1)",
                       pointColor: "rgba(151,187,205,1)",
                       pointStrokeColor: "#fff",
                       data: y_axis_data
                   }]
    }
  end

end
