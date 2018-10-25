class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :relationships
  has_many :users, through: :relationships
  validates :name, presence: true,
    length: {maximum: Settings.constant.name_max_length}
  scope :order_created_at, -> {order created_at: :desc}
end
