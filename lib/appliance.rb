module Appliance
  # Метод для получения html объекта Nokogiri
  def self.get_html(url)
    html = open(url) { |result| result.read }
    Nokogiri::HTML(html)
  end

  # Метод для записи ссылок на категории оборудования и карточек оборудования в .txt
  def self.write_to_txt(url, folder)
    folder = folder

    if folder == 'category_urls'
      file_name = url.split('/')[-2]
      File.write("./#{folder}/#{file_name}.txt", "#{url}\n", mode: 'a')
    elsif folder == 'appliance_urls'
      file_name = url.split('/')[3..4].join('_')
      File.write("./#{folder}/#{file_name}.txt", "#{url}\n", mode: 'a')
    else
      puts 'Директория для записи не найдена. ' +
           'Доступны: category_urls, appliance_urls'
    end
  end

  # Метод проверки наличия страниц пагинаций, параметр page - объект Nokogiri
  def self.pagination_valid?(page)
    page.css('body > div.container-fluid > div:nth-child(2) > 
              div.col-sm-8.col-md-7 > article > nav > ul.pagination').any?
  end

  # Метод вычисления количества страниц пагинаций, 
  # параметр page - объект Nokogiri
  def self.get_pagination_number(page)
    page.css('nav > ul.pagination > li')[-2].text.to_i
  end
end
