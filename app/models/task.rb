class Task < ApplicationRecord
  belongs_to :project
  has_many :cards
  validates :name, presence: true
  scope :order_by_created_at_desc, -> {order created_at: :desc}
end
