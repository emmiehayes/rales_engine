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

  def best_day
    invoices.select("invoices.*, sum(invoice_items.quantity) AS items_sold")
    .joins(:transactions, :invoice_items)
    .where(transactions: {result: 'success'})
    .group(:id).order("items_sold DESC")
    .limit(1)
    .first
    .created_at
  end
end
