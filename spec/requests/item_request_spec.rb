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
      expect(items[0]).to have_key(:created_at)
      expect(items[0]).to have_key(:updated_at)
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
      expect(item).to have_key(:created_at)
      expect(item).to have_key(:updated_at)
    end
  end

  context "GET /api/v1/items/:id/invoice_items" do
    it "returns all invoice_items for item" do
      merchant_1 = Merchant.create(name: 'blah')
      customer_1 = Customer.create(first_name: 'blahblah', last_name: 'blahblahblah')
      invoice_1 = Invoice.create(status: 'blahmillion', customer_id: customer_1.id, merchant_id: merchant_1.id)
      item_1 = Item.create(name: 'blahtrillion', description: '08/10/2018', unit_price: 1000, merchant_id: merchant_1.id)
      invoice_item_1 = invoice_1.invoice_items.create(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 7, unit_price: 333)
      invoice_item_2 = invoice_1.invoice_items.create(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 7, unit_price: 333)

      get "/api/v1/items/#{item_1.id}/invoice_items.json"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body, symbolize_names: true)

      expect(invoice_items.count).to eq(2)
      expect(invoice_items[0][:id]).to eq(invoice_item_1.id)
      expect(invoice_items[0][:item_id]).to eq(item_1.id)
      expect(invoice_items[0][:invoice_id]).to eq(invoice_1.id)
      expect(invoice_items[0][:quantity]).to eq(invoice_item_1.quantity)
      expect(invoice_items[0][:unit_price]).to eq("3.33")
    end
  end

  context "GET /api/v1/items/:id/merchant" do
    it "returns all merchant for item" do
      merchant_1 = Merchant.create!(name: 'blah')
      customer_1 = Customer.create!(first_name: 'blahblah', last_name: 'blahblahblah')
      item_1 = Item.create(name: 'blahtrillion', description: '08/10/2018', unit_price: 1000, merchant_id: merchant_1.id)

      get "/api/v1/items/#{item_1.id}/merchant.json"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:name]).to eq(merchant_1.name)
      expect(merchant[:id]).to eq(merchant_1.id)
    end
  end

  context "GET /api/v1/items/items/most_items?" do
    it "returns all items most sold" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant)
      item1 = create(:item)
      item2 = create(:item)
      item3 = create(:item)
      item4 = create(:item)
      customer = create(:customer)
      invoice1 = merchant1.invoices.create(customer_id: customer.id, status: 'something')
      invoice2 = merchant2.invoices.create(customer_id: customer.id, status: 'something')
      invoice3 = merchant3.invoices.create(customer_id: customer.id, status: 'something')
      invoice4 = merchant4.invoices.create(customer_id: customer.id, status: 'something')
      transaction1 = Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice1.id)
      transaction2 = Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice2.id)
      transaction2 = Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice3.id)
      transaction2 = Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice4.id)
      invoice_item1 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 1000)
      invoice_item1 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 1000)
      invoice_item2 = InvoiceItem.create(item_id: item2.id, invoice_id: invoice2.id, quantity: 2, unit_price: 1000)
      invoice_item2 = InvoiceItem.create(item_id: item2.id, invoice_id: invoice2.id, quantity: 2, unit_price: 1000)
      invoice_item3 = InvoiceItem.create(item_id: item3.id, invoice_id: invoice3.id, quantity: 4, unit_price: 1000)
      invoice_item3 = InvoiceItem.create(item_id: item3.id, invoice_id: invoice3.id, quantity: 4, unit_price: 1000)
      invoice_item4 = InvoiceItem.create(item_id: item4.id, invoice_id: invoice4.id, quantity: 3, unit_price: 1000)
      invoice_item4 = InvoiceItem.create(item_id: item4.id, invoice_id: invoice4.id, quantity: 3, unit_price: 1000)

      get "/api/v1/items/most_items?quantity=3"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(items[0][:id]).to eq(item3.id)
      expect(items[1][:id]).to eq(item4.id)
      expect(items[2][:id]).to eq(item2.id)
      expect(items.count).to eq(3)
    end
  end

  context "GET /api/v1/items/:id/most_revenue?" do
    it "returns top x item instances ranked by total number sold" do
      merchant_1 = Merchant.create(name: 'Apple')
      merchant_2 = Merchant.create(name: 'Banana')
      customer = Customer.create(first_name: 'Bob', last_name: 'Billy')
      item_1 = Item.create(name: 'box', description: 'square', unit_price: 100, merchant_id: merchant_1.id)
      item_2 = Item.create(name: 'box', description: 'square', unit_price: 500, merchant_id: merchant_2.id)
      item_3 = Item.create(name: 'box', description: 'square', unit_price: 700, merchant_id: merchant_1.id)
      item_4 = Item.create(name: 'box', description: 'square', unit_price: 1000, merchant_id: merchant_1.id)
      invoice_1 = Invoice.create(customer_id: customer.id, merchant_id: merchant_1.id, status:'test')
      invoice_2 = Invoice.create(customer_id: customer.id, merchant_id: merchant_2.id, status:'test')
      invoice_3 = Invoice.create(customer_id: customer.id, merchant_id: merchant_1.id, status:'test')
      invoice_4 = Invoice.create(customer_id: customer.id, merchant_id: merchant_2.id, status:'test')
      transaction_1 = invoice_1.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_2 = invoice_2.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_3 = invoice_3.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      transaction_4 = invoice_4.transactions.create(credit_card_number: 7678345678987654, credit_card_expiration_date: '08/10/2018', result: 'success')
      invoice_item_1 = InvoiceItem.create(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 2, unit_price: 200)
      invoice_item_2 = InvoiceItem.create(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 5, unit_price: 1000)
      invoice_item_3 = InvoiceItem.create(item_id: item_3.id, invoice_id: invoice_2.id, quantity: 7, unit_price: 4900)

      get "/api/v1/items/most_revenue?quantity=3"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items.count).to eq(3)
      expect(items[0][:id]).to eq(Item.third.id)   
    end
  end
end


     