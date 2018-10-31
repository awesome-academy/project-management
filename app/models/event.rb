class Event < ApplicationRecord
  belongs_to :card
  belongs_to :user
  enum event_type: {card_create: 1, card_update: 2, comment: 3}
  delegate :name, :id, :email, :to => :user, prefix: true
  validates :content, presence: true
  scope :order_by_created_at_desc, -> {order(created_at: :desc).includes(:user)}
end
