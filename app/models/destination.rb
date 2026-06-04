class Destination < ApplicationRecord
  belongs_to :user
  has_many :travel_expense_memos, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: { scope: :user_id }

  before_validation :normalize_name

  private

  def normalize_name
    self.name = name.to_s.strip
  end
end
