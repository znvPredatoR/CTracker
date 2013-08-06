module CurrenciesHelper

  def currencies_line_chart_data
    dates = []
    count = []
    UserVisit.order("created_at").each do |user_visit|
      date = user_visit.created_at.strftime("%b, %d")
      index = dates.index { |el| el == date }
      if user_visit.was_currency_collected
        if index
          count[index] += 1
        else
          dates << date
          count << 1
        end
      end
    end
    line_chart_obj(dates, count).to_json
  end

end
