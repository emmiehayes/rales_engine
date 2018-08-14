require 'rails_helper'

describe "invoices API" do
  context "get /api/v1/invoices" do
    it "sends a list of invoices" do
      create_list(:invoice, 3)

      get "/api/v1/invoices.json"

      expect(response).to be_successful

      invoices = JSON.parse(response.body, symbolize_names: true)

      invoice = invoices.first

      expect(invoices.count).to eq(3)
      expect(invoice).to have_key(:id)
      expect(invoice).to have_key(:status)
      expect(invoice).to_not have_key(:created_at)
      expect(invoice).to_not have_key(:updated_at)
    end
  end
  context "get /api/v1/invoices/:id" do
    it "can get one invoice by id" do
      id = create(:invoice).id

      get "/api/v1/invoices/#{id}.json"

      expect(response).to be_successful

      invoice = JSON.parse(response.body, symbolize_names: true)

      expect(invoice[:id]).to eq(id)
      expect(invoice).to have_key(:status)
      expect(invoice).to_not have_key(:created_at)
      expect(invoice).to_not have_key(:updated_at)
    end
  end
  context "GET /api/v1/invoices/find_all?" do
    it "returns objects that match query params" do
      create_list(:invoice, 3)

      invoice_1 = Invoice.first
      get "/api/v1/invoices/find_all?id=#{invoice_1.id}"

      expect(response).to be_successful

      invoices = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(invoices[0][:id]).to eq(invoice_1.id)
      expect(invoices[0][:status]).to eq(invoice_1.status)
      expect(invoices[0]).to have_key(:id)
      expect(invoices[0]).to have_key(:status)
      expect(invoices[0]).to_not have_key(:created_at)
      expect(invoices[0]).to_not have_key(:updated_at)
    end
    it "returns objects that match query params" do
      create_list(:invoice, 3)

      invoice_1 = Invoice.first
      get "/api/v1/invoices/find_all?status=#{invoice_1.status}"

      expect(response).to be_successful

      invoices = JSON.parse(response.body, symbolize_names: true)

      expect(invoices[0][:id]).to eq(invoice_1.id)
      expect(invoices[0][:status]).to eq(invoice_1.status)
      expect(invoices[0]).to have_key(:id)
      expect(invoices[0]).to have_key(:status)
      expect(invoices[0]).to_not have_key(:created_at)
      expect(invoices[0]).to_not have_key(:updated_at)
    end
  end
  context "GET /api/v1/invoices/find?" do
    it "returns objects that match query params" do
      create_list(:invoice, 3)

      invoice_1 = Invoice.first
      get "/api/v1/invoices/find?id=#{invoice_1.id}"

      expect(response).to be_successful

      invoice = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(invoice[:id]).to eq(invoice_1.id)
      expect(invoice[:status]).to eq(invoice_1.status)
      expect(invoice).to have_key(:id)
      expect(invoice).to have_key(:status)
      expect(invoice).to_not have_key(:created_at)
      expect(invoice).to_not have_key(:updated_at)
    end
  end
end
