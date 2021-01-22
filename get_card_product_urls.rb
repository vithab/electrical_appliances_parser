# Скрипт для получения списка урл карточек товаров, с заптсью в .txt

require 'open-uri'
require 'nokogiri'
require 'byebug'

require_relative 'lib/appliance'

category_urls = 
  File.open("./category_urls/autonics.txt", 'r'){ |file| file.readlines }
category_urls.map! { |link| link.strip }

document = Appliance.get_html(category_urls.first)
page_prefix = '?p='
total_card_links = []

# Проверка на существование html блока с пагинацией, если есть - берём кол-во
# страниц, собираем урл с префиксом '?p=', собираем ссылки на карточки с 
# каждой страницы пагинации.
# Если страниц пагинаций нет, собираем ссылки с текущей страницы.
if Appliance.pagination_valid?(document)
  page_number = Appliance.get_pagination_number(document)
  
  page_number.times do |number|
    url = category_urls.first + page_prefix + number.to_s
    page = Appliance.get_html(url)
    card_links_per_page = page.css('tbody div.row > div.col-xs-6 a')
      .map { |card_link| category_urls.first + card_link['href'] }
    
    total_card_links << card_links_per_page
  end
else
  card_links_per_page = page.css('tbody div.row div.col-xs-6 a')
    .map { |card_link| category_urls.first + card_link['href'] }

  total_card_links << card_links_per_page
end

p total_card_links
p total_card_links.size
