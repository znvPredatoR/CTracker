class UserVisit < ActiveRecord::Base
  attr_accessible :user_id, :country_id, :created_at

  belongs_to :user
  belongs_to :country

  validates_uniqueness_of :user_id, :scope => :country_id

  before_save :update_was_currency_collected

  private

  def update_was_currency_collected
    self.was_currency_collected = true unless country.currency.collected?(user_id)
  end

end
