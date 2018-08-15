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
end
