require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it {should have_many :invoices}
  it {should have_many :items}

  describe "instance methods" do
    it "can find the total revenue for one merchant" do
      merchant = Merchant.create!(name: 'merch')
      customer = Customer.create!(first_name: 'bob', last_name: 'jim')
      merchant.invoices.create(customer_id: customer.id, status: 'something')

    end
  end
end
