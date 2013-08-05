class CountriesController < ApplicationController

  def index
    @countries = Country.includes(:user_visits).all
  end

  def search
    @countries = Country.with_name params[:q]
    respond_to do |f|
      f.js
    end
  end

  def show
    @country = Country.find(params[:id])
  end

  def visit
    params[:selected_country_ids] && params[:selected_country_ids].each do |country_id|
      Country.find(country_id).visit(current_user.id)
    end
    @countries = Country.with_name params[:q]
    respond_to do |f|
      f.js
    end
  end

end