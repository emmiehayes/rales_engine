class MasterRevenueSerializer < ActiveModel::Serializer
  include ActionView::Helpers::NumberHelper
  attributes :total_revenue

  def total_revenue
    object.to_i.to_s.insert(-3, '.')
  end
end
