class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :destinations, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, confirmation: true, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  before_validation :normalize_name
  before_validation :ensure_email
  before_validation :normalize_email

  private

  def normalize_name
    self.name = name.to_s.strip
  end

  def ensure_email
    self.email = "user-#{SecureRandom.uuid}@example.invalid" if email.blank?
  end

  def normalize_email
    self.email = email.to_s.downcase.strip
  end

  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end
end
