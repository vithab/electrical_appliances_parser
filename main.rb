require 'open-uri'
require 'nokogiri'

require_relative 'lib/appliance'

BASE_URL = 'https://www.inortek.ru'

document = Appliance.get_html(BASE_URL)

# Получаем ссылки на страницы брендов
brand_urls = document.css('ul.list-group li.list-group-item a')
              .map { |item| BASE_URL + item['href'] }

p brand_urls

# Получаем ссылки на страницы категорий товаров брендов
appliances_urls = 
  brand_urls.map do |url|
    document = Appliance.get_html(url)
    document.css('nav > ul > li > a').map { |item| BASE_URL + item['href'] }
  end

puts "\n\n"
p appliances_urls

# Записываем в отдельный файл ссылки на категории каждого бренда
appliances_urls.map do |appliance_category|
  appliance_category.map { |url| Appliance.write_to_txt(url) }
end

puts "\n\nDone.\n\n"
