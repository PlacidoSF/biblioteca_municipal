class EmprestimosController < ApplicationController
  before_action :set_emprestimo, only: %i[ show ]

  def index
    @emprestimos = Emprestimo.includes(:livro, :usuario)

    if params[:status].present? && params[:status] != 'Todos'
      if params[:status] == 'Finalizado'
       
        @emprestimos = @emprestimos.where("LOWER(status) = ?", 'devolvido')
      elsif params[:status] == 'Atrasado'
       
        @emprestimos = @emprestimos.where("LOWER(status) != ? AND data_devolucao_prevista < ?", 'devolvido', Date.current)
      elsif params[:status] == 'Ativo'
        
        @emprestimos = @emprestimos.where("LOWER(status) != ? AND data_devolucao_prevista >= ?", 'devolvido', Date.current)
      end
    end
  end

  def finalizar
    @emprestimo = Emprestimo.find(params[:id])
    
    if @emprestimo.update(status: 'Devolvido')
      redirect_to emprestimos_path, notice: 'Empréstimo finalizado e livro devolvido ao acervo!'
    else
      redirect_to emprestimos_path, alert: 'Erro ao finalizar o empréstimo.'
    end
  end

  def show
  end

  def new
    @emprestimo = Emprestimo.new
  end

  def create
    @emprestimo = Emprestimo.new(emprestimo_params)

    if @emprestimo.save
      redirect_to emprestimos_path, notice: "Empréstimo registrado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
   
    def set_emprestimo
      @emprestimo = Emprestimo.find(params.expect(:id))
    end

    def emprestimo_params
      params.expect(emprestimo: [ :usuario_id, :livro_id, :data_emprestimo, :data_devolucao_prevista, :status, :senha_digitada ])
    end
end
