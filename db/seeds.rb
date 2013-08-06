require 'json'

# Create currencies
currency_data = File.read("./lib/currencies.json")
currencies = JSON.parse currency_data
currencies.each do |currency|
  Currency.create({name: currency[1], code: currency[0]})
end

# Create countries
countries_data = File.read("./lib/countries.json")
countries = JSON.parse countries_data
countries.each do |country|
  currency = Currency.find_by_code country["currency"]
  next unless currency
  Country.create({name: country["name"], code: country["cca2"], currency_id: currency.id})
end

# For the purposes of this demo let's purge countries without currencies and currencies without countries
Country.where("currency_id is null").each { |c| c.destroy }
Currency.all.each { |c| c.destroy if c.countries.empty? }

# Create test user and visits
u = User.create!({email: "qwe@qwe.qwe", password: "qweqweqwe", password_confirmation: "qweqweqwe"})
Country.all.sample(20).each do |c|
  from = 1.month.ago
  to = Time.now
  UserVisit.create({user_id: u.id, country_id: c.id, created_at: Time.at(from + rand * (to.to_f - from.to_f))})
end
