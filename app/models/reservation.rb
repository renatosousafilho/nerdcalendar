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
