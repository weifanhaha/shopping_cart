require 'rails_helper'

RSpec.describe Cart, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  describe "購物車基本功能" do
    it "可以把商品丟到到購物車裡，然後購物車裡就有東西了" do
      cart = Cart.new
      cart.add_item 1
      expect(cart.empty?).to be false
    end
    it "如果加了相同種類的商品到購物車裡，購買項目（CartItem）並不會增加，但商品的數量會改變" do
      cart = Cart.new
      3.times {cart.add_item 1}
      5.times {cart.add_item 2}
      2.times {cart.add_item 3}
      expect(cart.items.length).to be 3
      expect(cart.items.first.quantity).to be 3
      expect(cart.items.second.quantity).to be 5
    end
    it "商品可以放到購物車裡，也可以再拿出來" do
      cart = Cart.new
      p1 = Product.create(title: "Card House")
      p2 = Product.create(title: "Call Me By Your Name")

      4.times { cart.add_item(p1.id) }
      3.times { cart.add_item(p2.id) }

      expect(cart.items.first.product_id).to be p1.id
      expect(cart.items.second.product_id).to be p2.id
      expect(cart.items.first.product).to be_a Product
    end
    it "可以計算整台購物車的總消費金額" do
      p1 = Product.create(title: "Card House", price: 100)
      p2 = Product.create(title: "Call Me Maybe", price: 200)

      cart = Cart.new
      3.times{
        cart.add_item(p1.id)
        cart.add_item(p2.id)
      }

      expect(cart.total_price).to be 900
    end
    it "特別活動可能可搭配折扣（例如聖誕節的時候全面打 9 折，或是滿額滿千送百）"
  end

  describe "購物車進階功能" do
    it "可以將購物車內容轉換成 Hash，存到 Session 裡"
    it "可以把 Session 的內容（Hash 格式），還原成購物車的內容"
  end
end
