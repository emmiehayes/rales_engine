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

   context "GET /api/v1/merchants/most_revenue?quantity=x" do
    it "returns top x merchants based on total revenue " do
      merchant_1 = Merchant.create(name: 'Apple')
      merchant_2 = Merchant.create(name: 'Banana')
      merchant_3 = Merchant.create(name: 'Carrot')
      merchant_4 = Merchant.create(name: 'Dumpling')
     
      customer = Customer.create(first_name: 'Bob', last_name: 'Billy')

      item = Item.create(name: 'box', description: 'square', unit_price: 100, merchant_id: merchant_1.id)

      invoice_1 = Invoice.create(customer_id: customer.id, merchant_id: merchant_1.id, status:'test')
      invoice_2 = Invoice.create(customer_id: customer.id, merchant_id: merchant_2.id, status:'test')
      invoice_3 = Invoice.create(customer_id: customer.id, merchant_id: merchant_3.id, status:'test')
      invoice_4 = Invoice.create(customer_id: customer.id, merchant_id: merchant_4.id, status:'test')

      transaction_1 = invoice_1.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_2 = invoice_2.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_3 = invoice_3.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_4 = invoice_4.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')

      invoice_item_1 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_1.id, quantity: 4, unit_price: 400)
      invoice_item_2 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_1.id, quantity: 3, unit_price: 400)
      invoice_item_3 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_2.id, quantity: 3, unit_price: 400)
      invoice_item_3 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_2.id, quantity: 2, unit_price: 400)
      invoice_item_4 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_3.id, quantity: 2, unit_price: 400)
      invoice_item_5 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_3.id, quantity: 1, unit_price: 400)
      invoice_item_5 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_4.id, quantity: 2, unit_price: 400)

      get "/api/v1/merchants/most_revenue?quantity=3"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants.count).to eq(3)
      expect(merchants[0][:id]).to eq(Merchant.first.id)
    end
  end

  context "GET /api/v1/merchants/favorite_customer" do
    it "returns customer with most total number of successful transactions " do
      merchant_1 = Merchant.create(name: 'Apple')
      merchant_2 = Merchant.create(name: 'Banana')
      merchant_3 = Merchant.create(name: 'Carrot')
      merchant_4 = Merchant.create(name: 'Dumpling')
     
      customer_1 = Customer.create(first_name: 'Bob', last_name: 'Billy')

      item = Item.create(name: 'box', description: 'square', unit_price: 100, merchant_id: merchant_1.id)

      invoice_1 = Invoice.create(customer_id: customer_1.id, merchant_id: merchant_1.id, status:'test')
      invoice_2 = Invoice.create(customer_id: customer_1.id, merchant_id: merchant_2.id, status:'test')
      invoice_3 = Invoice.create(customer_id: customer_1.id, merchant_id: merchant_3.id, status:'test')
      invoice_4 = Invoice.create(customer_id: customer_1.id, merchant_id: merchant_4.id, status:'test')

      transaction_1 = invoice_1.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_2 = invoice_2.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_3 = invoice_3.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_4 = invoice_4.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')

      invoice_item_1 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_1.id, quantity: 4, unit_price: 400)
      invoice_item_2 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_1.id, quantity: 3, unit_price: 400)
      invoice_item_3 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_2.id, quantity: 3, unit_price: 400)
      invoice_item_3 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_2.id, quantity: 2, unit_price: 400)
      invoice_item_4 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_3.id, quantity: 2, unit_price: 400)
      invoice_item_5 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_3.id, quantity: 1, unit_price: 400)
      invoice_item_5 = InvoiceItem.create(item_id: item.id, invoice_id: invoice_4.id, quantity: 2, unit_price: 400)

      get "/api/v1/merchants/#{merchant_1.id}/favorite_customer.json"

      expect(response).to be_successful

      customer = JSON.parse(response.body, symbolize_names: true)

      expect(customer[:id]).to eq(customer_1.id)
    end
  end
end
