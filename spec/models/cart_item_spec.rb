require 'rails_helper'

RSpec.describe CartItem, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it "每個 Cart Item 都可以計算它自己的金額（小計）" do
    p1 = Product.create(title: "Card House", price: 80)
    p2 = Product.create(title: "Call Me Maybe", price: 100)

    cart = Cart.new
    2.times { cart.add_item(p1.id) }
    5.times { cart.add_item(p2.id) }
    3.times { cart.add_item(p1.id) }

    expect(cart.items.first.price).to be 400
    expect(cart.items.second.price).to be 500
  end
end
