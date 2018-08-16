require 'rails_helper'

RSpec.describe Item, type: :model do
  it { should belong_to :merchant }
  it { should have_many :invoice_items }
  it { should have_many :invoices }

  context "class methods" do
    it "returns all items most sold" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant)
      item1 = create(:item)
      item2 = create(:item)
      item3 = create(:item)
      item4 = create(:item)
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
      invoice_item2 = InvoiceItem.create(item_id: item2.id, invoice_id: invoice2.id, quantity: 2, unit_price: 1000)
      invoice_item2 = InvoiceItem.create(item_id: item2.id, invoice_id: invoice2.id, quantity: 2, unit_price: 1000)
      invoice_item3 = InvoiceItem.create(item_id: item3.id, invoice_id: invoice3.id, quantity: 4, unit_price: 1000)
      invoice_item3 = InvoiceItem.create(item_id: item3.id, invoice_id: invoice3.id, quantity: 4, unit_price: 1000)
      invoice_item4 = InvoiceItem.create(item_id: item4.id, invoice_id: invoice4.id, quantity: 3, unit_price: 1000)
      invoice_item4 = InvoiceItem.create(item_id: item4.id, invoice_id: invoice4.id, quantity: 3, unit_price: 1000)

      items = Item.most_sold(3)
      expect(items.length).to eq(3)
      expect(items).to eq([item3, item4, item2])
    end

    it '.most_revenue(quantity)' do
      merchant_1 = Merchant.create(name: 'Apple')
      merchant_2 = Merchant.create(name: 'Banana')
      customer = Customer.create(first_name: 'Bob', last_name: 'Billy')
      item_1 = Item.create(name: 'box', description: 'square', unit_price: 100, merchant_id: merchant_1.id)
      item_2 = Item.create(name: 'box', description: 'square', unit_price: 500, merchant_id: merchant_2.id)
      item_3 = Item.create(name: 'box', description: 'square', unit_price: 700, merchant_id: merchant_1.id)
      item_4 = Item.create(name: 'box', description: 'square', unit_price: 1000, merchant_id: merchant_1.id)
      invoice_1 = Invoice.create(customer_id: customer.id, merchant_id: merchant_1.id, status:'test')
      invoice_2 = Invoice.create(customer_id: customer.id, merchant_id: merchant_2.id, status:'test')
      invoice_3 = Invoice.create(customer_id: customer.id, merchant_id: merchant_1.id, status:'test')
      invoice_4 = Invoice.create(customer_id: customer.id, merchant_id: merchant_2.id, status:'test')
      transaction_1 = invoice_1.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_2 = invoice_2.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_3 = invoice_3.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_4 = invoice_4.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      invoice_item_1 = InvoiceItem.create(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 2, unit_price: 200)
      invoice_item_2 = InvoiceItem.create(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 5, unit_price: 1000)
      invoice_item_3 = InvoiceItem.create(item_id: item_3.id, invoice_id: invoice_2.id, quantity: 7, unit_price: 4900)

      expect(Item.most_revenue(3).first).to eq(item_3)
      expect(Item.most_revenue(3).second).to eq(item_2)
      expect(Item.most_revenue(3).last).to eq(item_1)
      expect(Item.most_revenue(3)).to_not include(item_4)
    end
  end

  context "instance methods" do
    it "returns best day for items" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant)
      item1 = create(:item)
      item2 = create(:item)
      item3 = create(:item)
      item4 = create(:item)
      customer = create(:customer)
      date1 = Date.parse("2000-1-1")
      date2 = Date.parse("2000-2-2")
      date3 = Date.parse("2000-3-3")
      date4 = Date.parse("2000-4-4")
      invoice1 = merchant1.invoices.create(customer_id: customer.id, status: 'something', created_at: date1)
      invoice2 = merchant2.invoices.create(customer_id: customer.id, status: 'something', created_at: date2)
      invoice3 = merchant3.invoices.create(customer_id: customer.id, status: 'something', created_at: date3)
      invoice4 = merchant4.invoices.create(customer_id: customer.id, status: 'something', created_at: date4)
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

      expect(item1.best_day).to eq(invoice3.created_at)
    end
  end
end
