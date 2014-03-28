class Reservable < ActiveRecord::Base
	has_many :reservations
	scope :reserved_at_date, lambda{ |date = Date.today| joins(:bookings).where("? BETWEEN bookings.start_at AND bookings.end_at and bookings.hosted=?", date, false) }
	scope :busy_at_date, lambda{ |date = Date.today| joins(:bookings).where("? BETWEEN bookings.start_at AND bookings.end_at and bookings.hosted=?", date, true) }
	scope :free_at_date, lambda{ |date = Date.today| where("id NOT IN (SELECT room_id FROM bookings WHERE (? between start_at and end_at))", date) }

	def has_reservations_between_dates?(start_date, end_date)
		bookings.where(["(start_at BETWEEN :start_at AND :end_at OR end_at BETWEEN :start_at AND :end_at)", {:start_at=> start_date, :end_at=> end_date}]).exists?
	end 

	def has_reservations_at_dates?(start_at, end_at)
		return bookings.where("(? BETWEEN start_at AND end_at OR ? BETWEEN start_at AND end_at)", start_at,end_at).exists?
	end
end
