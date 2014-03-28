FactoryGirl.define do
  factory :reservation do
  	 start_at Date.today
	 end_at Date.tomorrow
     
     factory :reservation_from_today_until_tomorrow do
	     start_at Date.today
	     end_at Date.tomorrow
     end
     
     factory :reservation_from_today_until_next_week do
	     start_at Date.today
	     end_at 1.week.since(Date.today)
     end

     
     factory :reservation_from_tomorrow_until_next_week do
	     start_at Date.tomorrow
	     end_at 1.week.since(Date.today)
	 end

	 factory :reservation_between_today_and_next_week do
	     start_at Date.today
	     end_at 1.week.since(Date.today)
     end

     factory :reservation_between_tomorrow_and_next_month do
	     start_at Date.tomorrow
	     end_at 2.week.since(Date.today)
     end
  end


end