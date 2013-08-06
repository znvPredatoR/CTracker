class Currency < ActiveRecord::Base
  attr_accessible :name, :code

  validates_presence_of :name
  validates_presence_of :code
  validates_uniqueness_of :code, :allow_blank => true

  has_many :countries

  scope :with_name, -> (q) { includes(:countries).where("name like ?", "%#{q}%") }

  def self.collected(user_id)
    includes(:countries).all.select {|currency| currency.collected?(user_id) }
  end

  def self.not_collected(user_id)
    includes(:countries).all.reject {|currency| currency.collected?(user_id) }
  end

  def collected?(user_id)
    countries.any? && countries.select { |c| c.visited?(user_id) }.any?
  end

  def collect(user_id)
    return unless countries.present?
    country = countries.first
    UserVisit.create({user_id: user_id, country_id: country.id})
  end
end