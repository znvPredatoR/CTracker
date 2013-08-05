class CurrenciesController < ApplicationController

  def index
    # todo eager load country visits
    @currencies = Currency.includes(:countries).all
  end

  def search
    @currencies = Currency.with_name params[:q]
    respond_to do |f|
      f.js
    end
  end

  def show
    @currency = Currency.find(params[:id])
  end

  def collect
    params[:selected_currency_ids] && params[:selected_currency_ids].each do |currency_id|
      Currency.find(currency_id).collect(current_user.id)
    end
    @currencies = Currency.with_name params[:q]
    respond_to do |f|
      f.js
    end
  end

end