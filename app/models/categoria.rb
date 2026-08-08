class Categoria < ApplicationRecord
  has_many :livros, dependent: :restrict_with_error
  validates :nome, presence: true, uniqueness: { case_sensitive: false }
end
