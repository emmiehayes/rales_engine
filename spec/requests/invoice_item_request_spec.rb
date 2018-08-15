require 'rails_helper'

describe "Invoices API" do
  context 'get /api/v1/invoice_items' do
    it "sends a list of invoice_items" do
      create_list(:invoice_item, 3)

      get "/api/v1/invoice_items.json"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body, symbolize_names: true)

      invoice_item = invoice_items.first

      expect(invoice_items.count).to eq(3)
      expect(invoice_item).to have_key(:id)
      expect(invoice_item).to have_key(:item_id)
      expect(invoice_item).to have_key(:invoice_id)
      expect(invoice_item).to have_key(:quantity)
      expect(invoice_item).to have_key(:unit_price)
      expect(invoice_item).to_not have_key(:created_at)
      expect(invoice_item).to_not have_key(:updated_at)
    end
  end
  context 'get /api/v1/invoice_items/:id' do
    it "sends a list of invoice_items" do
      create_list(:invoice_item, 3)
      inv_itm = Item.first
      get "/api/v1/invoice_items/#{inv_itm.id}.json"

      expect(response).to be_successful

      invoice_item = JSON.parse(response.body, symbolize_names: true)

      expect(invoice_item).to have_key(:id)
      expect(invoice_item).to have_key(:item_id)
      expect(invoice_item).to have_key(:invoice_id)
      expect(invoice_item).to have_key(:quantity)
      expect(invoice_item).to have_key(:unit_price)
      expect(invoice_item).to_not have_key(:created_at)
      expect(invoice_item).to_not have_key(:updated_at)
    end
  end
  context 'get /api/v1/invoice_items/find_all?' do
    it "find all invoice items by query" do
      create_list(:invoice_item, 3)
      inv_itm = Item.first

      get "/api/v1/invoice_items/find_all?id=#{inv_itm.id}.json"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body, symbolize_names: true)
      invoice_item = invoice_items.first

      expect(invoice_item).to have_key(:id)
      expect(invoice_item).to have_key(:item_id)
      expect(invoice_item).to have_key(:invoice_id)
      expect(invoice_item).to have_key(:quantity)
      expect(invoice_item).to have_key(:unit_price)
      expect(invoice_item).to_not have_key(:created_at)
      expect(invoice_item).to_not have_key(:updated_at)
    end
  end
  context 'get /api/v1/invoice_items/find?' do
    it "find all invoice items by query" do
      create_list(:invoice_item, 3)
      inv_itm = Item.first

      get "/api/v1/invoice_items/find?id=#{inv_itm.id}.json"

      expect(response).to be_successful

      invoice_item = JSON.parse(response.body, symbolize_names: true)

      expect(invoice_item).to have_key(:id)
      expect(invoice_item).to have_key(:item_id)
      expect(invoice_item).to have_key(:invoice_id)
      expect(invoice_item).to have_key(:quantity)
      expect(invoice_item).to have_key(:unit_price)
      expect(invoice_item).to_not have_key(:created_at)
      expect(invoice_item).to_not have_key(:updated_at)
    end
  end
  context 'get /api/v1/invoice_items/:id/invoice' do
    it "find all invoice items by query" do
      create_list(:invoice_item, 3)
      inv_itm = Item.first

      get "/api/v1/invoice_items/#{inv_itm.id}/invoice.json"

      expect(response).to be_successful

      invoice = JSON.parse(response.body, symbolize_names: true)

      expect(invoice).to have_key(:id)
      expect(invoice).to have_key(:status)
      expect(invoice).to_not have_key(:created_at)
      expect(invoice).to_not have_key(:updated_at)
    end
  end
  context 'get /api/v1/invoice_items/:id/item' do
    it "find all invoice items by query" do
      create_list(:invoice_item, 3)
      inv_itm = Item.first

      get "/api/v1/invoice_items/#{inv_itm.id}/item.json"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item).to have_key(:id)
      expect(item).to have_key(:name)
      expect(item).to have_key(:description)
      expect(item).to have_key(:unit_price)
      expect(item).to have_key(:merchant_id)
      expect(item).to_not have_key(:created_at)
      expect(item).to_not have_key(:updated_at)
    end
  end
end
