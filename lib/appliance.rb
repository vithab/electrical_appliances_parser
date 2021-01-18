module Appliance
  # Метод для получения html объекта Nokogiri
  def self.get_html(url)
    html = open(url) { |result| result.read }
    Nokogiri::HTML(html)
  end

  # Метод для записи ссылок категорий оборудования в .txt
  def self.write_to_txt(url)
    file_name = url.split('/')[-2]

    File.write("./category_urls/#{file_name}.txt", "#{url}\n", mode: 'a')
  end

  # Метод проверки наличия страниц пагинаций, параметр page - объект Nokogiri
  def self.pagination_valid?(page)
    page.css('body > div.container-fluid > div:nth-child(2) > 
              div.col-sm-8.col-md-7 > article > nav > ul.pagination').any?
  end
end
