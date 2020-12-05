require 'open-uri'
require 'nokogiri'

html = URI.open('https://www.inortek.ru')
document = Nokogiri::HTML(html)

puts document
