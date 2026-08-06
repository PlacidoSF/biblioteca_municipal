class Livro < ApplicationRecord
  belongs_to :categoria

  validates :titulo, :autor, presence: true

  validates :status, inclusion: { in: ["disponível", "emprestado"] }
end
