class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items
  has_many :invoice_items, through: :invoices

  def total_revenue(date = nil)
    inv = invoices
    date = Date.parse(date) if date
    inv = invoices.where(updated_at: date.beginning_of_day..date.end_of_day) if date
      inv
        .joins(:transactions, :invoice_items)
        .where(transactions: {result: 'success'})
        .sum("invoice_items.quantity*invoice_items.unit_price")
  end
end
