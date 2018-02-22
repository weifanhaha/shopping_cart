FactoryGirl.define do
  factory :order do
    totle_price 1
    aasm_state "MyString"
  end
end
