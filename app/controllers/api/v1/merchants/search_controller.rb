class Api::V1::Merchants::SearchController < ApplicationController
  def index
    render json: Merchant.all
  end
end