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

  context "GET /api/v1/merchants/:id/items" do
    it "returns single merchant items" do
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

  context "GET /api/v1/merchants/:id/invoices" do
    it "returns single merchant" do
      merchant_1 = Merchant.create(name: 'Apple')
      customer = Customer.create(first_name: 'Bob', last_name: 'Billy')

      invoice_1 = Invoice.create(customer_id: customer.id, merchant_id: merchant_1.id, status:'test')
      invoice_2 = Invoice.create(customer_id: customer.id, merchant_id: merchant_1.id, status:'test')
      invoice_3 = Invoice.create(customer_id: customer.id, merchant_id: merchant_1.id, status:'test')
      invoice_4 = Invoice.create(customer_id: customer.id, merchant_id: merchant_1.id, status:'test')

      get "/api/v1/merchants/#{merchant_1.id}/invoices.json"

      expect(response).to be_successful

      invoices = JSON.parse(response.body, symbolize_names: true)

      expect(invoices.count).to eq(4)
      expect(invoices[0]).to have_key(:id)
      expect(invoices[0]).to have_key(:status)
      expect(invoices[0]).to have_key(:merchant_id)
      expect(invoices[0]).to have_key(:customer_id)
      expect(invoices[0]).not_to have_key(:created_at)
      expect(invoices[0]).not_to have_key(:updated_at)
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
    it "returns customer with most total number of successful transactions" do
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

  context "GET /api/v1/merchants/most_items?quantity=x" do
    it "can see merchants with most items" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant)
      item1 = create(:item)
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
      invoice_item2 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice2.id, quantity: 2, unit_price: 1000)
      invoice_item2 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice2.id, quantity: 2, unit_price: 1000)
      invoice_item3 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice3.id, quantity: 4, unit_price: 1000)
      invoice_item3 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice3.id, quantity: 4, unit_price: 1000)
      invoice_item4 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice4.id, quantity: 3, unit_price: 1000)
      invoice_item4 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice4.id, quantity: 3, unit_price: 1000)

      get "/api/v1/merchants/most_items?quantity=3"

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchants[0][:id]).to eq(merchant3.id)
      expect(merchants[1][:id]).to eq(merchant4.id)
      expect(merchants[2][:id]).to eq(merchant2.id)
      expect(merchants.count).to eq(3)
    end
  end
  context "GET /api/v1/merchants/:id/customers_with_pending_invoices" do
    it "can find customers with pending invoices" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant)
      item1 = create(:item)
      customer1 = create(:customer)
      customer2 = create(:customer)
      customer3 = create(:customer)
      invoice1 = merchant1.invoices.create(customer_id: customer1.id, status: 'failed')
      invoice2 = merchant1.invoices.create(customer_id: customer1.id, status: 'failed')
      invoice3 = merchant3.invoices.create(customer_id: customer2.id, status: 'success')
      invoice4 = merchant4.invoices.create(customer_id: customer3.id, status: 'success')
      transaction1 = Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'failed', invoice_id: invoice1.id)
      transaction2 = Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'failed', invoice_id: invoice2.id)
      transaction2 = Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice3.id)
      transaction2 = Transaction.create(credit_card_number: '3435', credit_card_expiration_date: '10/11/12', result: 'success', invoice_id: invoice4.id)

      get "/api/v1/merchants/#{merchant1.id}/customers_with_pending_invoices"

      customers = JSON.parse(response.body, symbolize_names: true)

      expect(customers.length).to eq(1)
      expect(customers[0][:id]).to eq(customer1.id)
      expect(customers[0][:first_name]).to eq(customer1.first_name)
      expect(customers[0][:last_name]).to eq(customer1.last_name)
    end
  end
end
