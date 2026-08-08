class Livro < ApplicationRecord
  has_many :emprestimos, dependent: :restrict_with_error
  
  belongs_to :categoria

  validates :titulo, :autor, presence: true

  validates :status, inclusion: { in: ["disponível", "emprestado"] }
end
