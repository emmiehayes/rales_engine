require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it { should have_many :invoices }
  it { should have_many :items }
  it { should have_many(:invoice_items).through(:invoices) }
  it { should have_many(:transactions).through(:invoices) }
  it { should have_many(:customers).through(:invoices) }

  context 'instance methods' do
    it '.favorite_customer' do
      merchant_1 = Merchant.create(name: 'Apple')
      customer_1 = Customer.create(first_name: 'Bob', last_name: 'Billy')
      customer_2 = Customer.create(first_name: 'Jane', last_name: 'Billy')
      customer_3 = Customer.create(first_name: 'Susie', last_name: 'Billy')
      invoice_1 = Invoice.create(customer_id: customer_1.id, merchant_id: merchant_1.id, status:'test')
      invoice_2 = Invoice.create(customer_id: customer_1.id, merchant_id: merchant_1.id, status:'test')
      invoice_3 = Invoice.create(customer_id: customer_2.id, merchant_id: merchant_1.id, status:'test')
      invoice_4 = Invoice.create(customer_id: customer_3.id, merchant_id: merchant_1.id, status:'test')
      transaction_1 = invoice_1.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_2 = invoice_2.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_3 = invoice_3.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_4 = invoice_4.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')

      expect(merchant_1.favorite_customer).to eq(customer_1)
    end

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
    
    it "can find customers with pending invoices" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant)
      item1 = create(:item)
      customer1 = create(:customer)
      customer2 = create(:customer)
      customer3 = create(:customer)
      invoice1 = merchant1.invoices.create(customer_id: customer1.id, status: 'failed')
      invoice2 = merchant1.invoices.create(customer_id: customer1.id, status: 'failed')
      invoice3 = merchant3.invoices.create(customer_id: customer2.id, status: 'success')
      invoice4 = merchant4.invoices.create(customer_id: customer3.id, status: 'success')
      transaction1 = Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'failed', invoice_id: invoice1.id)
      transaction2 = Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'failed', invoice_id: invoice2.id)
      transaction2 = Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice3.id)
      transaction2 = Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice4.id)

      expect(merchant1.customers_with_pending_invoices).to eq([customer1])
    end
  end

  context "class methods" do
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
      transaction_1 = invoice_1.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_2 = invoice_2.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_3 = invoice_3.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_4 = invoice_4.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
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

    it "master_revenue(date)" do
      merchant_1 = create(:merchant)
      customer_1 = create(:customer)
      invoice_1 = merchant_1.invoices.create(customer_id: customer_1.id, status: 'something')
      invoice_2 = merchant_1.invoices.create(customer_id: customer_1.id, status: 'something')
      item_1 = merchant_1.items.create(name: 'blah', description: 'dkhgaer', unit_price: 1000)
      item_1 = merchant_1.items.create(name: 'blah', description: 'asjkgn', unit_price: 1000)
      Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice_1.id)
      Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice_2.id)
      invoice_item_1 = InvoiceItem.create(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 1000)
      invoice_item_2 = InvoiceItem.create(item_id: item_1.id, invoice_id: invoice_2.id, quantity: 2, unit_price: 1000)

      merchant_2 = create(:merchant)
      customer_2 = create(:customer)
      invoice_3 = merchant_2.invoices.create(customer_id: customer_2.id, status: 'something')
      invoice_4 = merchant_2.invoices.create(customer_id: customer_2.id, status: 'something')
      item_2 = merchant_2.items.create(name: 'blah', description: 'osit', unit_price: 1000)
      item_2 = merchant_2.items.create(name: 'blah', description: 'sagnero', unit_price: 1000)
      Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice_3.id)
      Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice_4.id)
      invoice_item_3 = InvoiceItem.create(item_id: item_2.id, invoice_id: invoice_3.id, quantity: 1, unit_price: 1000)
      invoice_item_4 = InvoiceItem.create(item_id: item_2.id, invoice_id: invoice_4.id, quantity: 2, unit_price: 1000)

      expect(Merchant.master_revenue("2018-08-16")).to eq(6000)
      expect(Merchant.master_revenue).to eq(6000)
    end
  end
end
