class Currency < ActiveRecord::Base
  attr_accessible :name, :code

  validates_presence_of :name
  validates_presence_of :code
  validates_uniqueness_of :code, :allow_blank => true

  has_many :countries

  def self.collected
    includes(:countries).all.select {|currency| currency.collected? }
  end

  def self.not_collected
    includes(:countries).all.reject {|currency| currency.collected? }
  end

  def collected?
    countries.any? && countries.select { |c| c.visited? }.any?
  end

  def collect(user_id)
    return unless countries.present?
    country = countries.first
    UserVisit.create({user_id: user_id, country_id: country.id})
  end
end