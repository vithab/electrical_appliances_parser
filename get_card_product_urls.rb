# Скрипт для получения списка урл карточек товаров, с заптсью в .txt

require 'open-uri'
require 'nokogiri'
require 'byebug'

require_relative 'lib/appliance'

folders = %w[category_urls appliance_urls]
category_urls = Dir['./category_urls/*.txt'].sort.map do |file|
  File.open("#{file}", 'r'){ |file| file.readlines }
end

# Проходимся по брендам и собираем категории (2 массив)
category_urls.map! { |brand| brand.map(&:strip) }
total_category_urls = category_urls.map(&:size).inject(0, :+)
puts "Всего на сайте найдено: #{total_category_urls} категорий"
puts '='*80

# TODO убрать диапазон [0..1] после проверок
category_urls[0..1].map do |brand|
  brand.map do |category_url|
    document = Appliance.get_html(category_url)
    page_prefix = '?p='
    
    # Общее количество ссылок на карточки товаров со всех страниц пагинаций
    # одной категории бренда
    total_card_links = []

    # Проверка на существование html блока с пагинацией, если есть - берём кол-во
    # страниц, собираем урл с префиксом '?p=', собираем ссылки на карточки с 
    # каждой страницы пагинации.
    # Если страниц пагинаций нет, собираем ссылки с текущей страницы.
    if Appliance.pagination_valid?(document)
      page_number = Appliance.get_pagination_number(document)
      
      page_number.times do |number|
        url = category_url + page_prefix + number.to_s
        page = Appliance.get_html(url)
        card_links_per_page = page.css('tbody div.row > div.col-xs-6 a')
          .map { |card_link| category_url + card_link['href'] }
        
        total_card_links << card_links_per_page
      end
        total_card_links.map do |pages|
          pages.map { |url| Appliance.write_to_txt(url, folders[1])}
        end
    elsif
      page = Appliance.get_html(url)
      card_links_per_page = page.css('tbody div.row div.col-xs-6 a')
        .map { |card_link| category_url + card_link['href'] }

      total_card_links << card_links_per_page
      total_card_links.map { |url| Appliance.write_to_txt(url, folders[1])}
    end



    puts "Текущая категория:\n#{category_url}\n\n"
    puts "Страниц пагинации в категории: #{total_card_links.size}"
    puts "Количество товаров в категории: #{total_card_links.flatten.size}"
    puts "="*80
  end
end
