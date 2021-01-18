# Скрипт для получения списка урл карточек товаров, с заптсью в .txt

require 'open-uri'
require 'nokogiri'

require_relative 'lib/appliance'

category_urls = 
  File.open("./category_urls/autonics.txt", 'r'){ |file| file.readlines }

category_urls.map! { |link| link.strip }

document = Appliance.get_html(category_urls.first)
document.css('tbody div.row div.col-xs-6 a')
  .map { |card_link| p category_urls.first + card_link['href'] }
