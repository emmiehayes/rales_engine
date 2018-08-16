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

      expect(merchant[:id]).to eq(merch.id)
      expect(merchant[:name]).to eq(merch.name)
      expect(merchant).to have_key(:id)
      expect(merchant).to have_key(:name)
      expect(merchant).to_not have_key(:created_at)
      expect(merchant).to_not have_key(:updated_at)
    end
  end

  context "GET /api/v1/merchants/:id" do
    it "returns single merchant" do
      merchant_1 = Merchant.create(name: 'Bob')
      item_1 = merchant_1.items.create(name: 'box', description: 'square', unit_price: 600)
      item_2 = merchant_1.items.create(name: 'bag', description: 'plastic', unit_price: 100)

      get "/api/v1/merchants/#{merchant_1.id}/items.json"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items.count).to eq(2)
      expect(items.first[:name]).to eq(item_1.name)
      expect(items.first[:description]).to eq(item_1.description)
      expect(items.first[:unit_price]).to eq('6.00')

    end
  end

  context "GET /api/v1/merchants/:id/revenue" do
    it "returns revenue for merchant" do
      merchant = create(:merchant)
      item1 = create(:item)
      customer = create(:customer)
      invoice1 = merchant.invoices.create(customer_id: customer.id, status: 'something')
      invoice2 = merchant.invoices.create(customer_id: customer.id, status: 'something')
      Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice1.id)
      Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice2.id)
      invoice_item1 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 1000)
      invoice_item2 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice2.id, quantity: 2, unit_price: 1000)

      get "/api/v1/merchants/#{merchant.id}/revenue"

      expect(response).to be_successful

      revenue = JSON.parse(response.body, symbolize_names: true)

      expect(revenue).to have_key(:revenue)
      expect(revenue).to_not have_key(:id)
      expect(revenue[:revenue]).to eq("30.00")
    end
    it "returns revenue for merchant given a date" do
      merchant = create(:merchant)
      item1 = create(:item)
      customer = create(:customer)
      invoice1 = merchant.invoices.create(customer_id: customer.id, status: 'something', updated_at: Date.parse('2012-10-31'))
      invoice2 = merchant.invoices.create(customer_id: customer.id, status: 'something')
      Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice1.id)
      Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice2.id)
      invoice_item1 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 1000)
      invoice_item2 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice2.id, quantity: 2, unit_price: 1000)

      get "/api/v1/merchants/#{merchant.id}/revenue?date=2012-10-31"

      expect(response).to be_successful

      revenue = JSON.parse(response.body, symbolize_names: true)

      expect(revenue).to have_key(:revenue)
      expect(revenue).to_not have_key(:id)
      expect(revenue[:revenue]).to eq("10.00")
    end
  end
end
