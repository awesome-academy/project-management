class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :relationships
  validates :name, presence: true,
    length: {maximum: Settings.constant.name_max_length}
  scope :select_info, -> {select :id, :name, :describe, :is_manager}
  scope :order_create, -> {order created_at: :desc}
  scope :joins_relationship, ->user do
    Project.joins(:relationships)
        .where :relationships => {user_id: user.id}
  end
  scope :get_by_user, ->user {
    joins_relationship(user).order_create.select_info
  }
end
