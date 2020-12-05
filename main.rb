require 'open-uri'
require 'nokogiri'

BASE_URL = 'https://www.inortek.ru'

html = URI.open(BASE_URL)
document = Nokogiri::HTML(html)

brands = document.css('ul.list-group li.list-group-item a').map { |item| BASE_URL + item['href'] }

p brands
