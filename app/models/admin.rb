class Admin < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable,
         :validatable, :trackable, :lockable

  has_many :events, dependent: :restrict_with_error
  has_many :reviewed_applications, class_name: "VisaLetterApplication", foreign_key: :reviewed_by_id, dependent: :nullify
  has_many :activity_logs, dependent: :nullify

  validates :first_name, presence: true, length: { maximum: 100 }
  validates :last_name, presence: true, length: { maximum: 100 }

  def full_name
    "#{first_name} #{last_name}"
  end
end
