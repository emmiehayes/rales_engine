class Item < ApplicationRecord
  belongs_to :merchant

  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.most_sold(quantity = 3)
    select("items.*, sum(invoice_items.quantity) AS sold_items")
    .joins(:invoice_items, invoices: [:transactions])
    .where(transactions: {result:'success'})
    .group(:id).order("sold_items DESC")
    .limit(quantity)
  end
end
