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
    it "商品可以放到購物車裡" do
      cart = Cart.new
      p1 = Product.create(title: "Card House")
      p2 = Product.create(title: "Call Me By Your Name")

      4.times { cart.add_item(p1.id) }
      3.times { cart.add_item(p2.id) }

      expect(cart.items.first.product_id).to be p1.id
      expect(cart.items.second.product_id).to be p2.id
      expect(cart.items.first.product).to be_a Product
    end
    it "商品可以從購物車裡拿出" do
      cart = Cart.new
      p1 = Product.create(title: "Card House")
      p2 = Product.create(title: "Call Me By Your Name")

      4.times { cart.add_item(p1.id) }
      3.times { cart.add_item(p2.id) }

      cart.delete_item p1.id
      expect(cart.items.length). to be 1
      expect(cart.items.first.product_id).to be p2.id
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
    it "特別活動可能可搭配折扣（例如聖誕節的時候全面打 9 折，或是滿額滿千送百）" do
      p1 = Product.create(title: "Card House", price: 100)
      p2 = Product.create(title: "Call Me Maybe", price: 200)

      cart = Cart.new
      5.times{
        cart.add_item(p1.id)
        cart.add_item(p2.id)
      }

      expect(cart.ninty_off).to be 1500 * 0.9
      expect(cart.hundred_free).to be 1500 - 100

      5.times{
        cart.add_item(p1.id)
        cart.add_item(p2.id)
      }

      expect(cart.hundred_free).to be 3000 - 300

    end
  end

  describe "購物車進階功能" do
    it "可以將購物車內容轉換成 Hash，存到 Session 裡" do
      cart = Cart.new
      3.times { cart.add_item 1}
      5.times { cart.add_item 2}

      expect(cart.serialize).to eq session_hash

    end
    it "可以把 Session 的內容（Hash 格式），還原成購物車的內容" do
      cart = Cart.from_hash(session_hash)

      expect(cart.items.first.product_id).to be 1
      expect(cart.items.first.quantity).to be 3
      expect(cart.items.second.product_id).to be 2
      expect(cart.items.second.quantity).to be 5
    end
  end
  private
  def session_hash
    {
      items: [
        { product_id: 1, quantity: 3},
        { product_id: 2, quantity: 5}
      ]
    }
  end
end
