class Usuario < ApplicationRecord
  has_many :emprestimos, dependent: :restrict_with_error
  
  validates :nome, :cpf, :telefone, :email, :senha_emprestimo, presence: true

  validates :email, uniqueness: true

  validates :cpf, uniqueness: true, length: { is: 11 }
  
  validates :telefone, length: { in: 10..15 }

  before_validation :gerar_senha_emprestimo, on: :create
  
  private

  def gerar_senha_emprestimo
    self.senha_emprestimo = SecureRandom.alphanumeric(6).upcase if senha_emprestimo.blank?
  end
end
