require "rails_helper"

describe "Merchants API" do
  context "GET /api/v1/merchants" do
    it "returns a list of merchants" do
      create_list(:merchant, 3)

      get "/api/v1/merchants.json"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      merchant = merchants.first

      expect(merchants.count).to eq(3)
      expect(merchant).to have_key(:id)
      expect(merchant).to have_key(:name)
    end
  end

  context "GET /api/v1/merchants/:id" do
    it "returns single merchant" do
      create_list(:merchant, 3)
      merch = Merchant.first

      get "/api/v1/merchants/#{merch.id}.json"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:id]).to eq(merch.id)
      expect(merchant).to have_key(:id)
      expect(merchant).to have_key(:name)
    end
  end
end
