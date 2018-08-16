class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :merchants, through: :invoices

  def favorite_merchant
    merchants.select("merchants.*, sum(invoice_items.quantity) AS items_sold")
    .joins(:invoices, :invoice_items)
    .group(:id)
    .order("items_sold DESC")
    .limit(1)
    .first
  end
end
