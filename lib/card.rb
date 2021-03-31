require 'open-uri'
require 'nokogiri'

require_relative 'appliance'

class Card
  attr_reader :url
  
  VENDOR_CODE_HTML_BLOCK = 'div:nth-child(1) > span:nth-child(5) > small'
  BRAND_HTML_BLOCK = 'div:nth-child(2) > div.col-sm-8.col-md-7 > ' \
                     'article > div > div > div > div:nth-child(1) > a'
  MODEL_HTML_BLOCK = 'h1'
  PRICE_HTML_BLOCK = 'h2 > span'
  DESCRIPTION_HTML_BLOCK = 'div:nth-child(2) > div.col-sm-8.col-md-7 > article' \
                           '> table > tbody > tr:nth-child(1) > td:nth-child(2)'
  BREADCRUMBS_HTML_BLOCK = 'ol.breadcrumb li'

  def initialize(url)
    @url         = url
    @vendor_code = nil
    @brand       = nil
    @model       = nil
    @price       = nil
    @description = nil
    @breadcrumbs = nil
  end

  def get_vendor_code(html_block)
    @vendor_code = 
      html_block.css(VENDOR_CODE_HTML_BLOCK).nil? ? '' : html_block.css(VENDOR_CODE_HTML_BLOCK).text.strip
  end
  
  def get_brand(html_block)
    @brand = 
      html_block.css(BRAND_HTML_BLOCK).nil? ? '' : html_block.css(BRAND_HTML_BLOCK).text.strip
  end

  def get_model(html_block)
    @model = 
      html_block.css(MODEL_HTML_BLOCK).nil? ? '' : html_block.css(MODEL_HTML_BLOCK).text.strip
  end

  def get_price(html_block)
    @price = 
      html_block.css(PRICE_HTML_BLOCK).nil? ? '' : html_block.css(PRICE_HTML_BLOCK).text
  end

  def get_description(html_block)
    @description = 
      html_block.css(DESCRIPTION_HTML_BLOCK).nil? ? '' : html_block.css(DESCRIPTION_HTML_BLOCK).text
  end

  def get_breadcrumbs(html_block)
    @breadcrumbs = html_block.css(BREADCRUMBS_HTML_BLOCK).map { |crumb| crumb.text.strip }
    @breadcrumbs.pop
    @breadcrumbs = @breadcrumbs.map { |crumb| crumb }.join(" -> ")
  end

  def get_attributes_card
    html = Appliance.get_html(url)
    html_block = html.css('.container-fluid')
   
    {
      vendor_code: get_vendor_code(html_block),
      brand: get_brand(html_block),
      model: get_model(html_block),
      price: get_price(html_block),
      description: get_description(html_block),
      breadcrumbs: get_breadcrumbs(html_block),
      url: @url
    }
  end
end
