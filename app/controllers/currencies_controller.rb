class CurrenciesController < ApplicationController

  def index
    @currencies = Currency.includes(:countries).all
  end

  def show
    @currency = Currency.find(params[:id])
  end
end