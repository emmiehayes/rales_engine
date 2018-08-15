class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items
  has_many :invoice_items, through: :invoices

  def self.most_revenue(quantity)
    select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue')
    .joins(:invoices, :invoice_items)
    .group(:id)
    .order('revenue DESC')
    .limit(quantity)
  end
end
