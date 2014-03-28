require 'spec_helper'

describe Reservation do 
  before :each do 
    @reservable = Reservable.create(:description=>"Fiat Uno")
  end

  it 'should not save without a reservable' do
    reservation = Reservation.new
    expect(reservation).to_not be_valid
  end

  it 'is invalid when ends before starts' do
    reservation = Reservation.new(reservable: @reservable, start_at:Date.tomorrow, end_at: Date.today)
    expect(reservation).to_not be_valid
  end

  context 'to same reservable' do
    before :each do 
      create(:reservation_from_today_until_next_week, reservable: @reservable)
    end

    it 'should not create for reserved dates' do
      expect(build(:reservation_from_today_until_tomorrow, reservable: @reservable)).to_not be_valid     
      expect(build(:reservation_from_today_until_next_week, reservable: @reservable)).to_not be_valid
      expect(build(:reservation_from_tomorrow_until_next_week, reservable: @reservable)).to_not be_valid
      expect(build(:reservation_between_today_and_next_week, reservable: @reservable)).to_not be_valid
      expect(build(:reservation_between_tomorrow_and_next_month, reservable: @reservable)).to_not be_valid
    end 
  end


end 
