require 'open-uri'
require 'nokogiri'

BASE_URL = 'https://www.inortek.ru'

html = URI.open(BASE_URL)
document = Nokogiri::HTML(html)

brand_urls = document.css('ul.list-group li.list-group-item a').map { |item| BASE_URL + item['href'] }

p brand_urls

html = URI.open(brand_urls.first)
document = Nokogiri::HTML(html)

appliances_urls = document.css('nav > ul > li > a').map { |item| BASE_URL + item['href'] }

puts "\n\n"
p appliances_urls
