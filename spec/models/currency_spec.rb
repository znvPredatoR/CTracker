require 'spec_helper'

describe Currency do
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:code).of_type(:string) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :code }

  it { should validate_presence_of :name }
  it { should validate_presence_of :code }
  it { should validate_uniqueness_of(:code) }

  describe 'collected?' do
    context 'when country has not been visited' do
      before do
        @user = User.create!(email: 'user@example.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe')
        @currency = Currency.create!(name: "US Dollar", code: "USD")
      end

      it 'is not collected' do
        @currency.collected?(@user.id).should be_false
      end
    end

    context 'when country has been visited' do
      before do
        @user = User.create!(email: 'user@example.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe')
        @currency = Currency.create!(name: "US Dollar", code: "USD")
        @country = Country.create!(name: 'United States', code: 'US', currency_id: @currency.id)
        UserVisit.create!({user_id: @user.id, country_id: @country.id})
      end

      it 'is not collected' do
        @currency.collected?(@user.id).should be_true
      end
    end
  end

  describe 'collected' do
    context 'when there is one collected currency and one not collected' do
      before do
        @user = User.create!(email: 'user@example.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe')
        @currency = Currency.create!(name: "US Dollar", code: "USD")
        @country = Country.create!(name: 'United States', code: 'US', currency_id: @currency.id)
        UserVisit.create!({user_id: @user.id, country_id: @country.id})

        other_user = User.create!(email: 'other_user@example.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe')
        other_currency = Currency.create!(name: "Ukrainian Hryvnya", code: "UAH")
        other_country = Country.create!(name: 'Ukraine', code: 'UA', currency_id: other_currency.id)
        UserVisit.create!({user_id: other_user.id, country_id: other_country.id})
      end

      it 'should return one collected currency' do
        Currency.collected(@user.id).should have(1).item
      end
    end

    context 'when there is no collected currencies' do
      before do
        @user = User.create!(email: 'user@example.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe')
      end

      it 'should return nothing' do
        Currency.collected(@user.id).should be_empty
      end
    end
  end

  describe 'not_collected' do
    context 'when there is one collected currency and one not collected' do
      before do
        @user = User.create!(email: 'user@example.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe')
        @currency = Currency.create!(name: "US Dollar", code: "USD")
        @country = Country.create!(name: 'United States', code: 'US', currency_id: @currency.id)
        UserVisit.create!({user_id: @user.id, country_id: @country.id})

        other_user = User.create!(email: 'other_user@example.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe')
        @other_currency = Currency.create!(name: "Ukrainian Hryvnya", code: "UAH")
        other_country = Country.create!(name: 'Ukraine', code: 'UA', currency_id: @other_currency.id)
        UserVisit.create!({user_id: other_user.id, country_id: other_country.id})
      end

      # first two come from fixtures
      it 'should return one that has not been collected' do
        not_collected_currencies = Currency.not_collected(@user.id)
        not_collected_currencies.should have(3).item
        not_collected_currencies.last.should eq(@other_currency)
      end
    end

    context 'when there is no collected currencies' do
      before do
        @user = User.create!(email: 'user@example.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe')
      end

      it 'should return nothing' do
        Currency.collected(@user.id).should be_empty
      end
    end
  end

end
