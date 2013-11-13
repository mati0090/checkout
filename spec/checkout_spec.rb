require './spec_helper'

describe Checkout do
  let(:checkout)  { Checkout.new }
  let(:apple)     { Item.new(:product_code => "AP1", :name => "Apple", :price => 5.00) }
  let(:coffee)    { Item.new(:product_code => "CF1", :name => "Coffee", :price => 11.23) }

  it "should count total price" do
    checkout.scan(apple)
    checkout.scan(coffee)

    checkout.total.should == 16.23
  end

end
