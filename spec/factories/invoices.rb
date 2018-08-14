FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status "MyString"
  end
end
