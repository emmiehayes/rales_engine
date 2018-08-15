require "rails_helper"

describe "Items API" do
  context "GET /api/v1/items" do
    it "returns a list of items" do
      merchant = Merchant.create(name: 'Bob')
      item_1 = merchant.items.create(name: 'ajslg', description: 'ashge', unit_price: 500)
      item_2 = merchant.items.create(name: 'ajslg', description: 'ashge', unit_price: 643)

      get "/api/v1/items.json"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      item = items.first

      expect(items.count).to eq(2)
      expect(item).to have_key(:id)
      expect(item).to have_key(:name)
      expect(item).to have_key(:description)
      expect(item).to have_key(:unit_price)
      expect(item).to have_key(:merchant_id)
      expect(item).to_not have_key(:created_at)
      expect(item).to_not have_key(:updated_at)
    end
  end

  context "GET /api/v1/items/:id" do
    it "returns single item" do
      merchant = Merchant.create(name: 'Bob')
      item_1 = merchant.items.create(name: 'ajslg', description: 'ashge', unit_price: 500)
      item_2 = merchant.items.create(name: 'ajslg', description: 'ashge', unit_price: 643)
      
      it = Item.first
      
      get "/api/v1/items/#{it.id}.json"
      
      expect(response).to be_successful
      
      item = JSON.parse(response.body, symbolize_names: true)
    
      expect(item[:id]).to eq(it.id)
      expect(item).to have_key(:id)
      expect(item).to have_key(:name)
      expect(item).to have_key(:description)
      expect(item).to have_key(:unit_price)
      expect(item).to have_key(:merchant_id)
      expect(item).to_not have_key(:created_at)
      expect(item).to_not have_key(:updated_at)
    end
  end
  
  context "GET /api/v1/items/find_all?" do
    it "returns objects that match query params" do
      merchant = Merchant.create(name: 'Bob')
      item_1 = merchant.items.create(name: 'ajslg', description: 'ashge', unit_price: 500)
      item_2 = merchant.items.create(name: 'ajslg', description: 'ashge', unit_price: 643)

      get "/api/v1/items/find_all?id=#{Item.first.id}"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[0][:id]).to eq(Item.first.id)
      expect(items[0][:name]).to eq(Item.first.name)
      expect(items[0]).to have_key(:id)
      expect(items[0]).to have_key(:name)
      expect(items[0]).to have_key(:description)
      expect(items[0]).to have_key(:unit_price)
      expect(items[0]).to have_key(:merchant_id)
      expect(items[0]).to_not have_key(:created_at)
      expect(items[0]).to_not have_key(:updated_at)
    end
  end

  context "GET /api/v1/items/find?" do
    it "returns object that matches query params" do
      merchant = Merchant.create(name: 'Bob')
      item_1 = merchant.items.create(name: 'ajslg', description: 'ashge', unit_price: 500)
      item_2 = merchant.items.create(name: 'ajslg', description: 'ashge', unit_price: 643)
      
      it = Item.first
      get "/api/v1/items/find?id=#{it.id}"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:id]).to eq(it.id)
      expect(item[:name]).to eq(it.name)
      expect(item).to have_key(:id)
      expect(item).to have_key(:name)
      expect(item).to have_key(:description)
      expect(item).to have_key(:name)
      expect(item).to_not have_key(:created_at)
      expect(item).to_not have_key(:updated_at)
    end
  end
end
