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
  unless currency
    puts "Can't find currency by code: #{country["currency"]} for #{country["name"]}. Ignore this message."
    next
  end
  Country.create({name: country["name"], code: country["cca2"], currency_id: currency.id})
end
