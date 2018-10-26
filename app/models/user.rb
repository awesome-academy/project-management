class User < ApplicationRecord
  has_many :cards
  has_many :relationships
  has_many :events
  has_many :projects, through: :relationships
  before_save {email.downcase!}
  validates :name, presence: true,
    length: {maximum: Settings.constant.name_max_length}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
    length: {maximum: Settings.constant.email_max_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.constant.password_min_length}
  scope :order_manager, -> {order "relationships.is_manager DESC"}
  scope :select_info, -> {select :id, :name, :email, :is_manager}
  scope :joins_relationship, ->project do
    User.joins(:relationships)
      .where :relationships => {project_id: project.id}
  end
  scope :get_user_belong_project, ->project do
    joins_relationship(project).select_info.order_manager
  end
  has_secure_password

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ?
      BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  def is_project_manager? project
    Relationship.find_by(user_id: self.id, project_id: project.id)
      .is_manager?
  end
end
