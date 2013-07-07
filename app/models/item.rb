class Item
  require 'rest_client'
  class << self
    def get_bulk(item_urls)
      items = []
      item_urls.each do |item_url|
        item = ActiveSupport::JSON.decode(RestClient.get 'http://vote4future.com:8080/api-1.0.0-BUILD-SNAPSHOT/products/item/', {:params => {:url => item_url}})
        #item = "http://thumbnail.image.rakuten.co.jp/@0_mall/toko0717/cabinet/02088250/7084.jpg?_ex=180x180"
        items.push item["itemDetails"] if item["code"] == 200
      end
      items
    end
  end
end
