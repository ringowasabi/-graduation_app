class TravelExpenseMemo < ApplicationRecord
  belongs_to :destination

  validates :departure_place, presence: true, length: { maximum: 100 }
  validates :arrival_place, presence: true, length: { maximum: 100 }
  validates :one_way_fare, presence: true, numericality: { only_integer: true, greater_than: 0 }

  before_validation :normalize_places

  def round_trip_fare
    one_way_fare.to_i * 2
  end

  private

  def normalize_places
    self.departure_place = departure_place.to_s.strip
    self.arrival_place = arrival_place.to_s.strip
  end
end
