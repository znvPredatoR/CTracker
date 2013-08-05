class UserVisit < ActiveRecord::Base
  attr_accessible :user_id, :country_id

  belongs_to :user
  belongs_to :country

  validates_uniqueness_of :user_id, :scope => :country_id
end
