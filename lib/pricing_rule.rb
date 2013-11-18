class PricingRule
  attr_accessor :product_code, :amount, :fixed_price, :custom_condition

  def initialize(attrs)
    attrs.each do |key, value|
      send("#{key}=", value)
    end
  end

  def discounts_difference(items)
    if (matches_items(items) || []).any? && custom_condition_match?(items)
      price_difference(items)
    else
      0
    end
  end

  private

    def price_difference(items)
      all_base_price(items) - all_fixed_price(items)
    end

    def matches_times(items)
      matches_items(items).count / amount
    end

    def matches_items(items)
      items.select {|i| i.product_code == product_code}
    end

    def single_base_price(items)
      matches_items(items).first.price
    end

    def all_base_price(items)
      base_price(items) * amount * matches_times(items)
    end

    def all_fixed_price(items)
      fixed_price * matches_times(items)
    end

    def base_price(items)
      matches_items(items).first.price
    end

    def custom_condition_match?(items)
      custom_condition.nil? || custom_condition.call(matches_times(items))
    end

end