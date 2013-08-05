class Country < ActiveRecord::Base
  attr_accessible :name, :code, :currency_id

  validates_presence_of :name
  validates_presence_of :code
  validates_uniqueness_of :code, :allow_blank => true

  # some countries have more than one currency (there is only like 10 of them)
  # for the purposes of this demo task I decided not to implement such case, it is kind of rare
  # if I would do this it'll be a has_and_belongs_to_many association
  # on the other hand situation when multiple countries has one currency is common (euro), so I decided to stick with it
  belongs_to :currency
  has_many :user_visits

  scope :with_name, -> (q) { includes(:user_visits).where("name like ?", "%#{q}%") }

  def visited?
    user_visits.present?
  end

  def visit(user_id)
    UserVisit.create({user_id: user_id, country_id: id})
  end

end