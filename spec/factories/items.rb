FactoryBot.define do
  factory :item do
    name "MyString"
    description "MyText"
    unit_price 1
    merchant
    created_at { Faker::Time.between(4.days.ago, Time.now, :all) }
    updated_at { Faker::Time.between(2.days.ago, Time.now, :all) }
  end
end
