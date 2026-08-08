class Usuario < ApplicationRecord
  has_many :emprestimos
  
  validates :nome, :cpf, :telefone, :email, :senha_emprestimo, presence: true
  validates :cpf, uniqueness: true

  validates :email, uniqueness: true

  before_validation :gerar_senha_emprestimo, on: :create
  
  private

  def gerar_senha_emprestimo
    self.senha_emprestimo = SecureRandom.alphanumeric(6).upcase if senha_emprestimo.blank?
  end
end
