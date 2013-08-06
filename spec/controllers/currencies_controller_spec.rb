require 'spec_helper'

describe CurrenciesController do
  before do
    @user = User.create!(email: 'user@example.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe')
    sign_in @user
  end

  describe 'POST "collect"' do
    before do
      @currency1 = Currency.create!(name: 'US Dollar', code: 'USD')
      @country1 = Country.create!(name: 'United States', code: 'US', currency_id: @currency1.id)
      @currency2 = Currency.create!(name: 'Russian Rubl', code: 'rub')
      @country2 = Country.create!(name: 'Russia', code: 'ru', currency_id: @currency2.id)

      other_currency = Currency.create!(name: 'Ukrainian Hryvna', code: 'UAH')
      Country.create!(name: 'Ukraine', code: 'UA', currency_id: other_currency.id)

      post :collect, { selected_currency_ids: [@currency1.id, @currency2.id] }
    end

    it 'should collect multiple currencies' do
      UserVisit.all.should have(2).items
      UserVisit.where(user_id: @user.id).pluck(:country_id).should =~ [@country1.id, @country2.id]
    end
  end
end
