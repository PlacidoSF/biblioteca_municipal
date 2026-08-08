class Livro < ApplicationRecord
  has_many :emprestimos
  
  belongs_to :categoria

  validates :titulo, :autor, presence: true

  validates :status, inclusion: { in: ["disponível", "emprestado"] }
end
