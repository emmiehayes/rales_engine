FactoryBot.define do
  factory :transaction do
    invoice
    credit_card_number 1
    credit_card_expiration_date "2018-08-14 12:22:31"
    result "MyString"
  end
end
