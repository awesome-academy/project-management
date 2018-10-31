class Task < ApplicationRecord
  belongs_to :project
  has_many :cards, dependent: :destroy
  validates :name, presence: true
  scope :order_by_created_at_asc, -> {order created_at: :asc}
end
