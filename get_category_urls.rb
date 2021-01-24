# Скрипт для получения списка урл категорий товаров брендов, с заптсью в .txt

require 'open-uri'
require 'nokogiri'

require_relative 'lib/appliance'

BASE_URL = 'https://www.inortek.ru'
folders = %w[category_urls appliance_urls]

document = Appliance.get_html(BASE_URL)

# Получаем ссылки на страницы брендов
brand_urls = document.css('ul.list-group li.list-group-item a')
              .map { |item| BASE_URL + item['href'] }

p brand_urls
puts

# Получаем ссылки на страницы категорий товаров брендов
category_urls = 
  brand_urls.map do |url|
    document = Appliance.get_html(url)
    document.css('nav > ul > li > a').map { |item| BASE_URL + item['href'] }
  end

# Записываем в отдельный файл ссылки на категории каждого бренда
category_urls.map do |url|
  url.map do |url|
    Appliance.write_to_txt(url, folders[0])
    p url
  end
end

puts "\n\nНайдено категорий брендов: #{category_urls.flatten.size}\n\n"
