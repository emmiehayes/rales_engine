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
  describe "class methods" do
    it "can find merchants with most items" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant)
      item1 = create(:item)
      customer = create(:customer)
      invoice1 = merchant1.invoices.create(customer_id: customer.id, status: 'something')
      invoice2 = merchant2.invoices.create(customer_id: customer.id, status: 'something')
      invoice3 = merchant3.invoices.create(customer_id: customer.id, status: 'something')
      invoice4 = merchant4.invoices.create(customer_id: customer.id, status: 'something')
      transaction1 = Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice1.id)
      transaction2 = Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice2.id)
      transaction2 = Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice3.id)
      transaction2 = Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice4.id)
      invoice_item1 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 1000)
      invoice_item1 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 1000)
      invoice_item2 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice2.id, quantity: 2, unit_price: 1000)
      invoice_item2 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice2.id, quantity: 2, unit_price: 1000)
      invoice_item3 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice3.id, quantity: 4, unit_price: 1000)
      invoice_item3 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice3.id, quantity: 4, unit_price: 1000)
      invoice_item4 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice4.id, quantity: 3, unit_price: 1000)
      invoice_item4 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice4.id, quantity: 3, unit_price: 1000)

      expect(Merchant.most_sold(3)).to eq([merchant3, merchant4, merchant2])
      expect(Merchant.most_sold(3)).not_to include(merchant1)
    end
  end
end
