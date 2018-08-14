require 'rails_helper'

describe "invoices API" do
  it "sends a list of invoices" do
    create_list(:invoice, 3)

    get "/api/v1/invoices.json"

    expect(response).to be_successful

    invoices = JSON.parse(response.body, symbolize_names: true)
    invoice = invoices.first

    expect(invoices.count).to eq(3)
    expect(invoice).to have_key(:id)
    expect(invoice).to have_key(:status)
  end
  it "can get one item by id" do
    id = create(:invoice).id

    get "/api/v1/invoices/#{id}.json"

    expect(response).to be_successful

    invoice = JSON.parse(response.body, symbolize_names: true)

    expect(invoice).to have_key(:id)
    expect(invoice).to have_key(:status)
  end
end
