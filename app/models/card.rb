class Card < ApplicationRecord
  belongs_to :user
  belongs_to :task
  has_many :events
end
