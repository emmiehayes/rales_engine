class TotalRevenueSerializer < ActiveModel::Serializer
  include ActionView::Helpers::NumberHelper
  attributes :revenue

  def revenue
    object.to_i.to_s.insert(-3, '.')
  end
end
