require 'csv'
require 'mailgun'
require_relative 'game_scraper'


#email client
Mailgun.configure do |config|
  config.api_key = 'key-9u1wnwp8c6d-5lby830nm6xz8gaixik7'
  config.domain  = 'sandbox92031.mailgun.org'
end
@mailgun = Mailgun()

#initialize nokogiri
sales = GameScraper.new('https://www.bigw.com.au/bigw/navigation/navigation_results.jsp?params=fh_eds%3D%25c3%259f%26omitxmldecl%3Dyes%26fh_user_date%3D20140404%26fh_refview%3Dlister%26fh_reffacet%3Dcategories%26fh_refpath%3Dfacet_61%26fh_location%3D%252f%252fcatalog01%252fen_AU%252fcategories%253c%257bcatalog01_2534374302023809%257d%252fcategories%253c%257bcatalog01_2534374302023809_2534374302023810%257d%252fcategories%253c%257bcatalog01_2534374302023809_2534374302023810_2534374302056352%257d%252fwebpromomarkdowntype%253e%257bin20this20week27s20brochure%253breduced20to20clear%257d%252fcategories%253c%257bcatalog01_2534374302023809_2534374302023810_2534374302056352_2534374302056355%257d&reset=false')

#csv
CSV.open("bigw_games.csv", "w") do |csv|
  csv << ["**3DS Games on promotion at BigW**"]
  csv << ["Title", "Price", "Availability", "Link"]
	sales.get_game.each do |game|
    csv << [game.css('.detail-panel h2').first,
            game.css('.price-panel .price').first,
            game.css('.price-panel p.in-store').first,
            game.css('.detail-panel h2 a').first["href"],]
  end
end

#email
parameters = {
  :to => "email@gmail.com",
  :subject => "3DS Games on promotion at BigW",
  :text => "Here are the latest 3DS games on promotion at BigW",
  :from => "kerrisongarcia@sandbox92031.mailgun.org",
  :attachment => File.open("bigw_games.csv")
}
@mailgun.messages.send_email(parameters)

