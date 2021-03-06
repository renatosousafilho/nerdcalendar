#NerdCalendar

A ideia é fazer este projeto se tornar uma gem para auxiliar a construção de sistemas que envolvam locações ou reservas.

Um modelo que for 'reservável' não pode ser reservado duas vezes em um mesmo intervalo de tempo, para isso criei os models Reservable que representa qualquer objeto ou serviço que pode ser alugado e Reservation que serve para representar uma reserva e através do mesmo ser capaz de saber se um objeto já está reservado.

##Reservable
```ruby
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
```

##Reservation
```ruby
class Reservation < ActiveRecord::Base
  belongs_to :reservable
  validates_presence_of :start_at, :end_at, :reservable_id
  validate :cannot_start_or_end_at_reserved_date, :cannot_end_at_be_less_than_start_at, :if => lambda{ |object| object.start_at.present? and object.end_at.present? }
  validate :cannot_start_at_past, :if => lambda{ |object| object.start_at.present? }
  validate :cannot_end_at_past, :if => lambda{ |object| object.end_at.present?}
  scope :excepts, lambda {|booking| where.not(:id=>booking.id)  }
  scope :between_dates, lambda{ |start_date = Date.today,end_date=Date.tomorrow| where(["(start_at BETWEEN :start_at AND :end_at OR end_at BETWEEN :start_at AND :end_at)", {:start_at=> start_date, :end_at=> end_date}]) }
  scope :at_dates, lambda{ |start_date = Date.today,end_date=Date.tomorrow| where("(? BETWEEN start_at AND end_at OR ? BETWEEN start_at AND end_at)", start_date,end_date) }

  before_save do
    self.start_at = self.start_at.to_date
    self.end_at = self.end_at.to_date
  end

  def cannot_start_or_end_at_reserved_date
    errors.add(:base, :invalid) if reservable.reservations.excepts(self).between_dates(start_at, end_at).exists? || reservable.reservations.excepts(self).at_dates(start_at, end_at).exists?
  end

  def cannot_end_at_be_less_than_start_at
    errors.add(:end_at, :inclusion) if end_at.before? start_at
  end
  
  def cannot_start_at_past
    errors.add(:start_at, :is_past) if self.start_at.is_past?
  end

  def cannot_end_at_past
    errors.add(:end_at, :is_past) if self.end_at.is_past?
  end
end
```

#O que precisa ser feito???

* Obter o status se o objeto reservável está livre ou ocupado e se possível uma terceira situação, reservado, ou seja aquele que ainda não foi efetivamente usado mas está reservado.
* Otimizar as queries e os mecanismos das validações.

Quem puder ajudar a contribuir pode se sentir a vontade, meu e-mail é renatosousafilho@gmail.com e twitter @renatosousafh.


#Dependências
```
rspec-rails
factory-girl
database_cleaner
```
