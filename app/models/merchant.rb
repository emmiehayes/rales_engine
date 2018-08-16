class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def favorite_customer
    customers.select('customers.*, COUNT(invoices.id) AS invoice_count')
      .joins(:transactions)
      .where(transactions: {result: 'success'})
      .group(:id)
      .order('invoice_count DESC')
      .limit(1)
      .first
  end

  def total_revenue(date = nil)
    inv = invoices
    date = Date.parse(date) if date
    inv = invoices.where(updated_at: date.beginning_of_day..date.end_of_day) if date
      inv
        .joins(:transactions, :invoice_items)
        .where(transactions: {result: 'success'})
        .sum("invoice_items.quantity*invoice_items.unit_price")
  end
  
  def self.most_revenue(limit = 3)
    select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
      .joins(:transactions, :invoice_items)
      .except(transactions: { result: 'failed' })
      .group('merchants.id')
      .order('total_revenue DESC')
      .limit(limit)
  end

  def self.most_sold(quantity = 3)
    select("merchants.*, sum(invoice_items.quantity) AS item_total")
    .joins(invoices: [:transactions, :invoice_items])
    .where(transactions: {result: 'success'})
    .group(:id).order("item_total DESC")
    .limit(quantity.to_i)
  end
end
