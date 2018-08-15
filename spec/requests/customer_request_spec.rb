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
end
