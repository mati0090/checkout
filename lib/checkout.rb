class Checkout
  attr_accessor :pricing_rules

  def scan(item)
    (@items ||= []) << item
  end

  def total
    (sum_items - discounts).round(2)
  end

  private

    def sum_items
      @items.inject(0) do |sum, item|
        sum += item.price
      end
    end

    def discounts
      (pricing_rules || []).inject(0) do |difference, pricing_rule|
        difference += pricing_rule.discounts_difference(@items)
      end
    end

end
