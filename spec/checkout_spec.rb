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

    describe "custom_conditional" do
      before(:each) do
        cheaper_apples = PricingRule.new(:product_code => "AP1", :amount => 1, :fixed_price => 4.5, :custom_condition => Proc.new {|matched_times| matched_times > 2})
        checkout.pricing_rules = [cheaper_apples]
      end

      it "works for 3 apples" do
        checkout.scan(apple)
        checkout.scan(apple)
        checkout.scan(apple)

        checkout.total.should == 13.50
      end

      it "does not work for 2 apples" do
        checkout.scan(apple)
        checkout.scan(apple)

        checkout.total.should == 10
      end

    end

    describe "scenarios" do
      let(:fruit_tea)         { Item.new(:product_code => "FR1", :name => "Fruit Tea", :price => 3.11) }
      let(:second_fr_free)    { PricingRule.new(:product_code => "FR1", :amount => 2, :fixed_price => 3.11) }
      let(:cheaper_apples)    { PricingRule.new(:product_code => "AP1", :amount => 1, :fixed_price => 4.5,
                                                :custom_condition => Proc.new {|matched_times| matched_times > 2}) }

      it "FR1, AP1, FR1, CF1" do
        checkout.scan(fruit_tea)
        checkout.scan(apple)
        checkout.scan(fruit_tea)
        checkout.scan(coffee)

        checkout.total.should == 22.45 #in description is 22.25
      end

      it "FR1, FR1" do
        checkout.pricing_rules = [second_fr_free]
        checkout.scan(fruit_tea)
        checkout.scan(fruit_tea)

        checkout.total.should == 3.11
      end

      it "AP1, AP1, FR1, AP1" do
        checkout.pricing_rules = [cheaper_apples]

        checkout.scan(apple)
        checkout.scan(apple)
        checkout.scan(fruit_tea)
        checkout.scan(apple)

        checkout.total.should == 16.61
      end

    end
  end

end
