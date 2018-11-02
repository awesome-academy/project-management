class Assign < ApplicationRecord
  belongs_to :card
  belongs_to :user
  validates :card, uniqueness: {scope: :user}, presence: true
  validates :user, uniqueness: {scope: :card}, presence: true
  scope :not_assign_yet, ->(project, card) {
    project.users.where.not user_id: card.users.pluck(:id)
  }
end
