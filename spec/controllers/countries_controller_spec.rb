require 'spec_helper'

describe CountriesController do
  before do
    @user = User.create!(email: 'user@example.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe')
    sign_in @user
  end

  describe 'POST "visit"' do
    before do
      @currency1 = Currency.create!(name: 'US Dollar', code: 'USD')
      @country1 = Country.create!(name: 'United States', code: 'US', currency_id: @currency1.id)
      @currency2 = Currency.create!(name: 'Russian Rubl', code: 'rub')
      @country2 = Country.create!(name: 'Russia', code: 'ru', currency_id: @currency2.id)

      other_currency = Currency.create!(name: 'Ukrainian Hryvna', code: 'UAH')
      Country.create!(name: 'Ukraine', code: 'UA', currency_id: other_currency.id)

      post :visit, { selected_country_ids: [@country1.id, @country2.id] }
    end

    it 'visits multiple countries' do
      UserVisit.all.should have(2).items
      UserVisit.where(user_id: @user.id).pluck(:country_id).should =~ [@country1.id, @country2.id]
    end
  end

  describe 'POST "visit" two countries with same currency' do
    before do
      @currency1 = Currency.create!(name: 'Euro', code: 'EUR')
      @country1 = Country.create!(name: 'Germany', code: 'GR', currency_id: @currency1.id)
      @country2 = Country.create!(name: 'France', code: 'FR', currency_id: @currency1.id)

      post :visit, { selected_country_ids: [@country1.id, @country2.id] }
    end

    it 'visits multiple countries but only first country should have currency_was_collected = true' do
      visits = UserVisit.all
      visits.should have(2).items
      visits[0].was_currency_collected.should be_true
      visits[1].was_currency_collected.should be_false
      UserVisit.where(user_id: @user.id).pluck(:country_id).should =~ [@country1.id, @country2.id]
    end
  end

end
