require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it {should have_many :invoices}
  it {should have_many :items}

  context 'class methods' do
    it 'most_revenue(quantity)' do
      merchant_1 = Merchant.create(name: 'Apple')
      merchant_2 = Merchant.create(name: 'Banana')
      merchant_3 = Merchant.create(name: 'Carrot')
      merchant_4 = Merchant.create(name: 'Dumpling')
     
      customer = Customer.create(first_name: 'Bob', last_name: 'Billy')

      item = Item.create(name: 'box', description: 'square', unit_price: 100, merchant_id: merchant_1.id)

      invoice_1 = Invoice.create(customer_id: customer.id, merchant_id: merchant_1.id, status:'test')
      invoice_2 = Invoice.create(customer_id: customer.id, merchant_id: merchant_2.id, status:'test')
      invoice_3 = Invoice.create(customer_id: customer.id, merchant_id: merchant_3.id, status:'test')
      invoice_4 = Invoice.create(customer_id: customer.id, merchant_id: merchant_4.id, status:'test')
     
      invoice_item_1 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_1.id, quantity: 4, unit_price: 400)
      invoice_item_2 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_1.id, quantity: 3, unit_price: 400)
      invoice_item_3 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_2.id, quantity: 3, unit_price: 400)
      invoice_item_3 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_2.id, quantity: 2, unit_price: 400)
      invoice_item_4 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_3.id, quantity: 2, unit_price: 400)
      invoice_item_5 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_3.id, quantity: 1, unit_price: 400)
      invoice_item_5 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_4.id, quantity: 2, unit_price: 400)

      expect(Merchant.most_revenue(3).first).to eq(merchant_1)
      expect(Merchant.most_revenue(3).second).to eq(merchant_2)
      expect(Merchant.most_revenue(3).last).to eq(merchant_3)
      expect(Merchant.most_revenue(3)).to_not include(merchant_4)
    end
  end
end
