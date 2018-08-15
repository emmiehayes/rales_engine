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
end
