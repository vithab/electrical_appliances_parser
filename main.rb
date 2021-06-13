require_relative 'lib/card'
require 'byebug'

brand_category_urls = Dir['./appliance_urls/*.txt'].sort.map do |file|
  File.open("#{file}", 'r'){ |file| file.readlines }
end

# Количество категорий брендов (файлов в папке /appliance_urls/)
brand_category_counter = brand_category_urls.count

# Для валидности url, убираем перенос строки '\n' после чтения из файлов
brand_category_urls.map! { |card_url| card_url.map(&:strip) }

array_cards = []

brand_category_urls[3..4].map.with_index do |brand_category, n|
  brand_category.map.with_index do |card_url, i|
    card = Card.new(card_url)
    array_cards << card.get_attributes_card
    puts "Категория № #{n + 1}. Всего категорий #{brand_category_counter}"
    puts "Карточка категории бренда № #{i + 1} из #{brand_category.count}\n\n"
    p card.get_attributes_card
    puts '=' * 80
  end
end
