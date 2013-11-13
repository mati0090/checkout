class Checkout

  def scan(item)
    (@items ||= []) << item
  end

  def total
    @items.inject(0) do |sum, item|
      sum += item.price
    end
  end

end
