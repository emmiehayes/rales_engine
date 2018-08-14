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

  context "GET /api/v1/merchants/:id" do
    it "returns single merchant" do
     merchant_1 = Merchant.create(name: 'Bob')
     item_1 = merchant_1.items.create(name: 'box', description: 'square', unit_price: 600)
     item_2 = merchant_1.items.create(name: 'bag', description: 'plastic', unit_price: 100)
      
      get "/api/v1/merchants/#{merchant_1.id}/items.json"
      
      expect(response).to be_successful
      
      items = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to have_http_status(200)
      expect(items.count).to eq(2)
      expect(items.first[:name]).to eq(item_1.name)
      expect(items.first[:description]).to eq(item_1.description)
      expect(items.first[:unit_price]).to eq(item_1.unit_price)
      end
    end
  end
end
