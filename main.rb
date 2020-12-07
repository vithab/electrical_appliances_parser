require 'open-uri'
require 'nokogiri'

BASE_URL = 'https://www.inortek.ru'

def get_html(url)
  html = open(url) { |result| result.read }
  Nokogiri::HTML(html)
end

def write_to_txt(url)
  file_name = url.split('/')[-2]

  File.write("./appliances_urls/#{file_name}.txt", "#{url}\n", mode: 'a')
end

document = get_html(BASE_URL)
brand_urls = document.css('ul.list-group li.list-group-item a').map { |item| BASE_URL + item['href'] }

p brand_urls

document = get_html(brand_urls.first)

appliances_urls = document.css('nav > ul > li > a').map { |item| BASE_URL + item['href'] }

puts "\n\n"
p appliances_urls

appliances_urls.map { |url| write_to_txt(url) }

puts "\n\nDone.\n\n"
