class Card < ApplicationRecord
  belongs_to :user
  belongs_to :task
  has_many :assigns, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :users, through: :assigns
  validates :name, presence: true
end
