class Api::V1::Customers::RandomController < ApplicationController
  def show
    render json: Customer.order("RANDOM()").first
  end
end
