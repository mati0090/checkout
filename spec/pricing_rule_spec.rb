require './spec_helper'

describe PricingRule do
  let(:pricing_rule) { PricingRule.new(:product_code => "FR1", :amount => 5, :fixed_price => 20) }

  it "should assign attributes" do
    pricing_rule.product_code.should  == "FR1"
    pricing_rule.amount.should        == 5
    pricing_rule.fixed_price.should   == 20
  end
end