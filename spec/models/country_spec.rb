require 'spec_helper'

describe Country do
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:code).of_type(:string) }
  it { should have_db_column(:currency_id).of_type(:integer) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :code }

  it { should validate_presence_of :name }
  it { should validate_presence_of :code }
  it { should validate_uniqueness_of(:code) }

  describe 'visited?' do
    context 'when no visits' do
      subject { Country.create!(name: 'a', code: 'b') }

      it 'is not visited' do
        subject.visited?(User.new).should be_false
      end
    end

    context 'when visits exist' do
      before do
        @user = User.create!(email: 'user@example.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe')
        @currency = Currency.create!(name: "US Dollar", code: "USD")
        @country = Country.create!(name: 'United States', code: 'US', currency_id: @currency.id)
        UserVisit.create!(user_id: @user.id, country_id: @country.id)
      end

      it 'is visited' do
        @country.visited?(@user.id).should be_true
      end
    end
  end

  describe 'visit' do
    before do
      @currency = Currency.create!(name: "US Dollar", code: "USD")
      @country = Country.create!(name: 'United States', code: 'US', currency_id: @currency.id)
      @user = User.create!(email: 'user@example.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe')
    end

    it 'should be visited' do
      @country.visit(@user.id).should be_true
      UserVisit.where(user_id: @user.id, country_id: @country.id).should have(1).item
    end
  end
end
