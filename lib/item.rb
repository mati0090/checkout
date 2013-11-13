class Item
  attr_accessor :product_code, :name, :price

  def initialize(attrs)
    attrs.each do |key, value|
      send("#{key}=", value)
    end
  end
end
