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

  describe "pricing rules" do
    let(:pricing_rule) { PricingRule.new(:product_code => "AP1", :amount => 5, :fixed_price => 20) }

    before(:each) do
      checkout.pricing_rules = [pricing_rule]
    end

    it "should check for single pricing rule" do
      5.times { checkout.scan(apple) }

      checkout.total.should == 20
    end

    it "should check for multiple pricing rules" do
      another_pricing_rule = PricingRule.new(:product_code => "CF1", :amount => 3, :fixed_price => 22.46)
      checkout.pricing_rules << another_pricing_rule

      5.times { checkout.scan(apple) }
      4.times { checkout.scan(coffee) }

      checkout.total.should == 20 + 22.46 + 11.23
    end
  end

end
