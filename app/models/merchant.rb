class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def favorite_customer
    customers.select('customers.*, COUNT(invoices.id) AS invoice_count')
    .joins(:transactions)
    .merge(Transaction.success)
    .group(:id)
    .order('invoice_count DESC')
    .limit(1)
    .first
  end

  def total_revenue(date = nil)
    if date
      date = Date.parse(date)
      invoices
      .where(updated_at: date.beginning_of_day..date.end_of_day)
      .joins(:transactions, :invoice_items)
      .merge(Transaction.success)
      .sum("invoice_items.quantity*invoice_items.unit_price")
    else
      invoices
      .joins(:transactions, :invoice_items)
      .merge(Transaction.success)
      .sum("invoice_items.quantity*invoice_items.unit_price")
    end
  end

  def customers_with_pending_invoices
    customers.find_by_sql("
      SELECT customers.* FROM customers
      INNER JOIN invoices ON customers.id = invoices.customer_id
      INNER JOIN transactions ON invoices.id = transactions.invoice_id
      WHERE invoices.merchant_id = #{id}
      EXCEPT
      SELECT customers.* FROM customers
      INNER JOIN invoices ON customers.id = invoices.customer_id
      INNER JOIN transactions ON invoices.id = transactions.invoice_id
      WHERE invoices.merchant_id = #{id}
      AND transactions.result = 'success';")
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
    .merge(Transaction.success)
    .group(:id)
    .order("item_total DESC")
    .limit(quantity.to_i)
  end

  def self.master_revenue(date = nil)
    if date
      date = Date.parse(date)
      joins(invoices: [:transactions, :invoice_items])
      .where(invoices: { updated_at: date.beginning_of_day..date.end_of_day})
      .merge(Transaction.success)
      .sum('invoice_items.quantity * invoice_items.unit_price')
    else
      joins(invoices: [:transactions, :invoice_items])
      .merge(Transaction.success)
      .sum('invoice_items.quantity * invoice_items.unit_price')
    end
  end
end
