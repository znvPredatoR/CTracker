class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :user_visits
  has_many :visited_countries, through: :user_visits, source: :country

  def not_visited_countries
    return Country.all unless visited_countries.present?
    Country.where("id not in (#{visited_countries.pluck(:id).join(",")})")
  end

end
