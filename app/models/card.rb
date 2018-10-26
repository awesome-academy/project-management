class Card < ApplicationRecord
  belongs_to :user
  belongs_to :task
  has_many :events, dependent: :destroy
  validates :name, presence: true
end
