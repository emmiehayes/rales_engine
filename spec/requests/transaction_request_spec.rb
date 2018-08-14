require 'rails_helper'

describe "Transactions API" do
  context "GET /api/v1/transactions" do
    it "returns a list of transactions" do
      create_list(:transaction, 3)

      get "/api/v1/transactions.json"

      expect(response).to be_successful

      transactions = JSON.parse(response.body, symbolize_names: true)
      transaction = transactions.first

      expect(response).to have_http_status(200)
      expect(transactions.count).to eq(3)
      expect(transaction).to have_key(:id)
      expect(transaction).to have_key(:invoice_id)
      expect(transaction).to have_key(:result)
      expect(transaction).to_not have_key(:credit_card_number)
      expect(transaction).to_not have_key(:credit_card_expiration_date)
      expect(transaction).to_not have_key(:created_at)
      expect(transaction).to_not have_key(:updated_at)
    end
  end
end