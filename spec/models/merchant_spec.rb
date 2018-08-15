require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it {should have_many :invoices}
  it {should have_many :items}

  describe "instance methods" do
    it "can find the total revenue for one merchant" do
      merchant = create(:merchant)
      item1 = create(:item)
      customer = create(:customer)
      invoice1 = merchant.invoices.create(customer_id: customer.id, status: 'something')
      invoice2 = merchant.invoices.create(customer_id: customer.id, status: 'something')
      Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice1.id)
      Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice2.id)
      invoice_item1 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 1000)
      invoice_item2 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice2.id, quantity: 2, unit_price: 1000)

      expect(merchant.total_revenue).to eq(3000)
    end
  end
end
