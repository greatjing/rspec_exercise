class Parking < ApplicationRecord
  # 必填项
  validates_presence_of :parking_type, :start_at
  # 只能选项
  validates_inclusion_of :parking_type, :in => ["guest", "short-term", "long-term"]
  # 强制结束时间和金额一起填写
  validate :validate_end_at_with_amount

  def validate_end_at_with_amount
    if ( end_at.present? && amount.blank? )
      errors.add(:amount, "有结束时间就必须有金额")
    end
    if ( end_at.blank? && amount.present? )
      errors.add(:end_at, "有金额必须有结束时间")
    end
  end

end
