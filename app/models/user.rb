class User < ApplicationRecord
  has_many :cards
  has_many :relationships
  has_secure_password
end
