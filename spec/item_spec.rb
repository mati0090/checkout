require './spec_helper'

describe Item do
  let(:item) { Item.new(:product_code => "FR1", :name => "Fruit Tea", :price => 3.11) }

  it "should assign attributes" do
    item.product_code.should  == "FR1"
    item.name.should          == "Fruit Tea"
    item.price.should         == 3.11
  end
end
