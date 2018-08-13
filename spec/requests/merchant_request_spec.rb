require "rails_helper"

describe "Items API" do
 context "GET /api/v1/merchants" do
   it "returns a list of merchants" do
     create_list(:merchant, 3)

     get "/api/v1/merchants"

     expect(response).to be_successful

     merchants = JSON.parse(response.body, symbolize_names: true)
     merchant = merchants.first

     expect(merchants.count).to eq(3)
     expect(merchant).to have_key(:name)
     expect(merchant).to have_key(:created_at)
     expect(merchant).to have_key(:updated_at)
   end
 end
end
