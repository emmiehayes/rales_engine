class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items
  has_many :invoice_items, through: :invoices

  def total_revenue
    invoices
      .joins(:transactions, :invoice_items)
      .where(transactions: {result: 'success'})
      .sum("invoice_items.quantity*invoice_items.unit_price")
  end
end
