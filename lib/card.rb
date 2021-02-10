require 'open-uri'
require 'nokogiri'

require_relative 'appliance'

class Card
  attr_accessor :url

  def initialize(url)
    @url = url
  end

  def get_attributes_card
    html = Appliance.get_html(url)
    
    html_block = html.css('.container-fluid')

    vendor_code = html_block.css('div:nth-child(1) > span:nth-child(5) > small').text.chomp.strip

    brand = html_block.css('div:nth-child(2) > div.col-sm-8.col-md-7 > article > div > div > div > div:nth-child(1) > a').text.chomp.strip  
    model = html_block.css('h1').text.strip
    
    unless html_block.css('h2 > span').nil?
      price = html_block.css('h2 > span').text
    else
      price = ''
    end

    unless html_block.css('div:nth-child(2) > div.col-sm-8.col-md-7 > article > table > tbody > tr:nth-child(1) > td:nth-child(2)').nil?
      description = html_block.css('div:nth-child(2) > div.col-sm-8.col-md-7 > article > table > tbody > tr:nth-child(1) > td:nth-child(2)').text.chomp.strip
    else
      description = ''
    end

    breadcrumbs = []
    html_block.css('ol.breadcrumb li').map {|crumb| breadcrumbs << crumb.text.chomp.strip}
    breadcrumbs.pop
    
    breadcrumbs = breadcrumbs.map { |crumb| crumb}.join(" -> ")

    url = @url.chomp.strip

    card = {
      vendor_code: vendor_code,
      brand: brand,
      model: model,
      price: price,
      description: description,
      breadcrumbs: breadcrumbs,
      url: url
    }
  end
end
