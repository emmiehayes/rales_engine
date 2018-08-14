FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status { Faker::StarWars.character }
  end
end
