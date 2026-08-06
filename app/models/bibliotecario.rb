class Bibliotecario < ApplicationRecord
  has_secure_password

  validates :nome, presence: true
  validates :email, presence: true, uniqueness: true
end
