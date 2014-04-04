require 'nokogiri'
require 'open-uri'

class GameScraper
	def initialize(url)
		@doc = Nokogiri::HTML(open(url))
	end

	def get_game
		@doc.css('.product-panel')
	end

	def css(x)
		@doc.css(x)
	end
end