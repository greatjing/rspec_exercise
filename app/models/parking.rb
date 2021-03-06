class Parking < ApplicationRecord
  # 必填项
  validates_presence_of :parking_type, :start_at
  # 只能选项
  validates_inclusion_of :parking_type, :in => ["guest", "short-term", "long-term"]
  # 强制结束时间和金额一起填写
  validate :validate_end_at_with_amount
  # 与user产生关联关系
  belongs_to :user, :optional => true
  #
  before_validation :setup_amount

# 限制金额和结束时间的输出
  def validate_end_at_with_amount
    # if ( end_at.present? && amount.blank? )
    #   errors.add(:amount, "有结束时间就必须有金额")
    # end
    if ( end_at.blank? && amount.present? )
      errors.add(:end_at, "有金额必须有结束时间")
    end
  end

  def duration
    ( end_at - start_at ) / 60
  end

  # def calculate_amount
  def setup_amount
    # factor = (self.user.present?)? 50 : 100

    if self.amount.blank? && self.start_at.present? && self.end_at.present?
      if self.user.blank?
        self.amount = calculate_guest_term_amount
      elsif self.parking_type == "short-term"
        self.amount = calculate_short_term_amount
      elsif self.parking_type == "long-term"
        self.amount = calculate_long_term_amount
      end

      #self.amount = 1111
      # if duration <= 60
      #   self.amount = 200
      # end
      # total = 0
      # if duration <= 60
      #   self.amount = 200
      # else
      #   self.amount = 200 + ((duration - 60).to_f / 30).ceil * factor
      #   # total += 200
      #   # left_duration = duration - 60
      #   # total += ( left_duration.to_f / 30 ).ceil * 100
      # end
      # self.amount = total
    end
  end

  def calculate_guest_term_amount
    if duration <= 60
      self.amount = 200
    else
      self.amount = 200 + ((duration - 60).to_f / 30 ).ceil * 100
    end
  end

  def calculate_short_term_amount
    if duration <= 60
      self.amount = 200
    else
      self.amount = 200 + ((duration - 60).to_f / 30 ).ceil * 50
    end
  end

  def calculate_long_term_amount
    puts duration.to_i / 1440
    if duration < 360
      # 打印信息
      # puts "______"
      self.amount = 1200
    else
      # puts "******"
      if duration.to_i % 1440 == 0
        self.amount = (duration.to_i / 1440) * 1600
      else
        self.amount = ((duration.to_i / 1440) + 1) * 1600
      end
    end
  end


end
