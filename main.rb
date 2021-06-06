require_relative 'lib/card'

card_urls = Dir['./appliance_urls/*.txt'].sort.map do |file|
  File.open("#{file}", 'r'){ |file| file.readlines }
end

# Для валидности url, убираем перенос строки '\n' после чтения из файлов
card_urls.map! { |card_url| card_url.map(&:strip) }

array_cards = []

card_urls[0..1].map do |brand|
  brand.map do |card_url|
    card = Card.new(card_url)
    array_cards << card.get_attributes_card
    p card.get_attributes_card
    puts '=' * 80
  end
end

p array_cards
