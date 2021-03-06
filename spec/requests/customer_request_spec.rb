require 'rails_helper'

describe "Customers API" do
  context 'get /api/v1/customers' do
    it "sends a list of customers" do
      create_list(:customer, 3)

      get "/api/v1/customers.json"

      expect(response).to be_successful

      customers = JSON.parse(response.body, symbolize_names: true)

      customer = customers.first

      expect(customers.count).to eq(3)
      expect(customer).to have_key(:id)
      expect(customer).to have_key(:first_name)
      expect(customer).to have_key(:last_name)
      expect(customer).to_not have_key(:created_at)
      expect(customer).to_not have_key(:updated_at)
    end
  end

  context 'get /api/v1/customers/random' do
    it "sends a list of customers" do
      create_list(:customer, 3)

      get "/api/v1/customers/random.json"

      expect(response).to be_successful

      customer = JSON.parse(response.body, symbolize_names: true)

      expect(customer).to have_key(:id)
      expect(customer).to have_key(:first_name)
      expect(customer).to have_key(:last_name)
      expect(customer).to_not have_key(:created_at)
      expect(customer).to_not have_key(:updated_at)
    end
  end

  context "GET /api/v1/customers/:id" do
    it "returns single customer" do
      create_list(:customer, 3)
      cust = Customer.first

      get "/api/v1/customers/#{cust.id}.json"

      expect(response).to be_successful

      customer = JSON.parse(response.body, symbolize_names: true)

      expect(customer[:id]).to eq(cust.id)
      expect(customer).to have_key(:first_name)
      expect(customer).to have_key(:last_name)
      expect(customer).to_not have_key(:created_at)
      expect(customer).to_not have_key(:updated_at)
    end
  end

  context "GET /api/v1/customers/find_all?" do
    it "returns objects that match query params" do
      customer_1 = Customer.create(first_name: 'blah', last_name: 'blahblah')
      customer_2 = Customer.create(first_name: 'blahblah', last_name: 'blahblahblah')

      get "/api/v1/customers/find_all?id=#{Customer.first.id}"

      expect(response).to be_successful

      customers = JSON.parse(response.body, symbolize_names: true)

      expect(customers[0][:id]).to eq(Customer.first.id)
      expect(customers[0][:first_name]).to eq(Customer.first.first_name)
      expect(customers[0][:last_name]).to eq(Customer.first.last_name)
      expect(customers[0]).to_not have_key(:created_at)
      expect(customers[0]).to_not have_key(:updated_at)
    end
  end

  context "GET /api/v1/customers/find?" do
    it "returns object that matches query params" do
      customer_1 = Customer.create(first_name: 'blah', last_name: 'blahblah')
      customer_2 = Customer.create(first_name: 'blahblah', last_name: 'blahblahblah')

      cust = Customer.first
      get "/api/v1/customers/find?id=#{cust.id}"

      expect(response).to be_successful

      customer = JSON.parse(response.body, symbolize_names: true)

      expect(customer[:id]).to eq(cust.id)
      expect(customer[:first_name]).to eq(cust.first_name)
      expect(customer[:last_name]).to eq(cust.last_name)
      expect(customer).to_not have_key(:created_at)
      expect(customer).to_not have_key(:updated_at)
    end
  end

  context 'get /api/v1/customers/:id/invoices' do
    it "returns collection of invoices per customer query" do
      merchant = Merchant.create(name: 'blah')
      customer = Customer.create(first_name: 'blahblah', last_name: 'blahblahblah')
      invoice_1 = Invoice.create(status: 'blahmillion', customer_id: customer.id, merchant_id: merchant.id)
      invoice_2 = Invoice.create(status: 'blahtrillion', customer_id: customer.id, merchant_id: merchant.id)

      get "/api/v1/customers/#{customer.id}/invoices.json"

      expect(response).to be_successful

      invoices = JSON.parse(response.body, symbolize_names: true)

      expect(invoices[0][:customer_id]).to eq(customer.id)
      expect(invoices[1][:customer_id]).to eq(customer.id)
      expect(invoices[0][:status]).to eq(invoice_1.status)
      expect(invoices[1][:status]).to eq(invoice_2.status)
      expect(invoices[0]).to_not have_key(:created_at)
      expect(invoices[1]).to_not have_key(:updated_at)
    end
  end

  context 'get /api/v1/customers/:id/transactions' do
    it "returns collection of transactions per customer query" do
      merchant = Merchant.create(name: 'blah')
      customer = Customer.create(first_name: 'blahblah', last_name: 'blahblahblah')
      invoice = Invoice.create(status: 'blahmillion', customer_id: customer.id, merchant_id: merchant.id)
      transaction_1 = Transaction.create(invoice_id: invoice.id, credit_card_number: 345678567893245, credit_card_expiration_date: "2018-08-14 12:22:31", result: 'milliom')
      transaction_2 = Transaction.create(invoice_id: invoice.id, credit_card_number: 879876546745676, credit_card_expiration_date: "2018-07-14 08:24:01", result: 'billion')

      get "/api/v1/customers/#{customer.id}/transactions.json"

      expect(response).to be_successful

      transactions = JSON.parse(response.body, symbolize_names: true)

      expect(transactions[0][:invoice_id]).to eq(invoice.id)
      expect(invoice.customer_id).to eq(customer.id)
      expect(transactions.count).to eq(2)
    end
  end

  context "GET /api/v1/customers/:id/favorite_merchant" do
    it "favorite merchant for customer" do
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

      get "/api/v1/customers/#{customer.id}/favorite_merchant"

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:id]).to eq(merchant3.id)
      expect(merchant[:name]).to eq(merchant3.name)
    end
  end
end
