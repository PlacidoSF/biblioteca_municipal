class Emprestimo < ApplicationRecord
  belongs_to :usuario
  belongs_to :livro

  attr_accessor :senha_digitada

  validates :data_emprestimo, :data_devolucao_prevista, :status, presence: true
  validate :validar_senha_do_usuario, on: :create

  before_validation :configurar_dados_iniciais, on: :create
  after_create :marcar_livro_como_emprestado
  after_update :sincronizar_status_do_livro, if: :saved_change_to_status?

  def status_dinamico
    return 'Finalizado' if status.downcase == 'devolvido' || status.downcase == 'finalizado'
    return 'Atrasado' if Date.current > data_devolucao_prevista
    'Ativo'
  end

  def valor_multa
    return 0.0 unless status_dinamico == 'Atrasado'
    
    dias_atraso = (Date.current - data_devolucao_prevista).to_i
    
    dias_atraso * 1.5 
  end

  private

  def validar_senha_do_usuario
    return unless usuario.present?

    if senha_digitada.blank?
      errors.add(:senha_digitada, "precisa ser informada para confirmar a transação")
    elsif senha_digitada != usuario.senha_emprestimo
      errors.add(:senha_digitada, "inválida. Solicite a senha correta ao usuário.")
    end
  end

  def configurar_dados_iniciais
    self.data_emprestimo ||= Date.current
    self.status ||= "Ativo"

    if self.data_devolucao_prevista.blank?
      dias_uteis = 15
      data_calculada = self.data_emprestimo

      while dias_uteis > 0
        data_calculada += 1.day
        dias_uteis -= 1 unless data_calculada.saturday? || data_calculada.sunday?
      end

      self.data_devolucao_prevista = data_calculada
    end
  end

  def marcar_livro_como_emprestado
    livro.update!(status: 'emprestado')
  end

  def sincronizar_status_do_livro
    if self.status == 'Devolvido'
      livro.update!(status: 'disponível')
    else
      livro.update!(status: 'emprestado')
    end
  end
end