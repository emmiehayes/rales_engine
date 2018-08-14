require "rails_helper"

describe "Merchants API" do
  context "GET /api/v1/merchants" do
    it "returns a list of merchants" do
      create_list(:merchant, 3)

      get "/api/v1/merchants.json"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      merchant = merchants.first

      expect(response).to have_http_status(200)
      expect(merchants.count).to eq(3)
      expect(merchant).to have_key(:id)
      expect(merchant).to have_key(:name)
      expect(merchant).to_not have_key(:created_at)
      expect(merchant).to_not have_key(:updated_at)
    end
  end

  context "GET /api/v1/merchants/:id" do
    it "returns single merchant" do
      create_list(:merchant, 3)
      merch = Merchant.first
      
      get "/api/v1/merchants/#{merch.id}.json"
      
      expect(response).to be_successful
      
      merchant = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(200)
      expect(merchant[:id]).to eq(merch.id)
      expect(merchant).to have_key(:id)
      expect(merchant).to have_key(:name)
      expect(merchant).to_not have_key(:created_at)
      expect(merchant).to_not have_key(:updated_at)
    end
  end
  
  context "GET /api/v1/merchants/find_all?" do
    it "returns objects that match query params" do
      create_list(:merchant, 3)

      get "/api/v1/merchants/find_all?id=#{Merchant.first.id}"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(merchants[0][:id]).to eq(Merchant.first.id)
      expect(merchants[0][:name]).to eq(Merchant.first.name)
      expect(merchants[0]).to have_key(:id)
      expect(merchants[0]).to have_key(:name)
      expect(merchants[0]).to_not have_key(:created_at)
      expect(merchants[0]).to_not have_key(:updated_at)
    end
  end

    context "GET /api/v1/merchants/find?" do
    it "returns object that matches query params" do
      create_list(:merchant, 3)
      merch = Merchant.first
      get "/api/v1/merchants/find?id=#{merch.id}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(merchant[:id]).to eq(merch.id)
      expect(merchant[:name]).to eq(merch.name)
      expect(merchant).to have_key(:id)
      expect(merchant).to have_key(:name)
      expect(merchant).to_not have_key(:created_at)
      expect(merchant).to_not have_key(:updated_at)
    end
  end
end
