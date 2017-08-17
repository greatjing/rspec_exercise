require 'rails_helper'

RSpec.describe Parking, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe ".validate_end_at_with_amount" do
    it "is invalid without amount" do
      parking = Parking.new( :parking_type => "guest",
                             :start_at => Time.now - 6.hours,
                             :end_at => Time.now)
      expect( parking ).to_not be_valid
    end

    it "is invalid without end_at" do
      parking = Parking.new( :parking_type => "guest",
                            :start_at => Time.now - 6.hours,
                            :amount => 100 )
      expect( parking ).to_not be_valid
    end
  end

  describe ".calculate_amount" do
    # 一般用户的计费校验
    context "guest" do
      it "30 mins should be ¥2" do
        t = Time.now
        parking = Parking.new( :parking_type => "guest", :start_at => t, :end_at => t + 30.minutes )
        parking.calculate_amount
        expect(parking.amount).to eq(200)
      end

      it " 60 mins should be ¥2 " do
        t = Time.now
        parking = Parking.new( :parking_type => "guest", :start_at => t, :end_at => t + 60.minutes )
        parking.calculate_amount
        expect(parking.amount).to eq(200)
      end

      it "61 mins should be ¥3" do
        t = Time.now
        parking = Parking.new( :parking_type => "guest", :start_at => t, :end_at => t + 61.minutes )
        parking.calculate_amount
        expect(parking.amount).to eq(300)
      end

      it "90 mins should be ¥3" do
        t = Time.now
        parking = Parking.new( :parking_type => "guest", :start_at => t, :end_at => t + 90.minutes )
        parking.calculate_amount
        expect(parking.amount).to eq(300)
      end

      it "120 mins should be ¥4" do
        t = Time.now
        parking = Parking.new( :parking_type => "guest", :start_at => t, :end_at => t + 120.minutes )
        parking.calculate_amount
        expect(parking.amount).to eq(400)
      end
    end

    # 短期费率
    context "short-term" do
      it " 30 mins should be ¥2 " do
        t =  Time.now
        parking = Parking.new( :parking_type => "short-term", :start_at => t, :end_at => t + 30.minutes )
        parking.user = User.create(:email => "test@examples.com", :password => "123456" )
        parking.calculate_amount
        expect(parking.amount).to eq(200)
      end

      it " 60 mins should be 2 " do
        t = Time.now
        parking = Parking.new( :parking_type => "short-term", :start_at => t, :end_at => t + 60.minutes )
        parking.user = User.new(:email => "test@examples.com", :password => "123456")
        parking.calculate_amount
        expect(parking.amount).to eq(200)
      end

      it "61 mins should be ¥3" do
        t = Time.now
        parking = Parking.new( :parking_type => "guest", :start_at => t, :end_at => t + 61.minutes )
        parking.user = User.new(:email => "test@examples.com", :password => "123456")
        parking.calculate_amount
        expect(parking.amount).to eq(250)
      end

      it "90 mins should be ¥3" do
        t = Time.now
        parking = Parking.new( :parking_type => "guest", :start_at => t, :end_at => t + 90.minutes )
        parking.user = User.new(:email => "test@examples.com", :password => "123456")
        parking.calculate_amount
        expect(parking.amount).to eq(250)
      end

      it "120 mins should be ¥4" do
        t = Time.now
        parking = Parking.new( :parking_type => "guest", :start_at => t, :end_at => t + 120.minutes )
        parking.user = User.new(:email => "test@examples.com", :password => "123456")
        parking.calculate_amount
        expect(parking.amount).to eq(300)
      end

    end

  end

end
