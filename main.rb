require_relative 'lib/card'

card_urls = [
        'https://www.inortek.ru/sensor/emkostnye_beskontaktnye_vyklyuchateli/vbe-m30-73k-1111-sa.html',
        'https://www.inortek.ru/autonics/zapchasti_dlya_svetosignalnoj_apparatury/AP_B.html',
        'https://www.inortek.ru/autonics/absolyutnyj_enkoder/EP50S8_1024_1F_N_24.html'
       ]

array_cards = []

card_urls.map do |url|
  card = Card.new(url)
  array_cards << card.get_attributes_card
  p card.get_attributes_card
  puts '=' * 80
end

p array_cards
