class ActivityLog < ApplicationRecord
  belongs_to :trackable, polymorphic: true
  belongs_to :admin, optional: true

  validates :action, presence: true
  validates :trackable, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def self.log!(trackable:, action:, admin: nil, metadata: {}, request: nil)
    create!(
      trackable: trackable,
      action: action,
      admin: admin,
      metadata: metadata,
      ip_address: request&.remote_ip,
      user_agent: request&.user_agent
    )
  end
end
