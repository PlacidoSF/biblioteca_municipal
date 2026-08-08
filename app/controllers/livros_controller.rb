class LivrosController < ApplicationController
  before_action :set_livro, only: %i[ edit update destroy ]

  def index
    @livros = Livro.includes(:categoria).all
  end

  def new
    @livro = Livro.new
  end

  def create
    @livro = Livro.new(livro_params)

    if @livro.save
      redirect_to livros_path, notice: 'Livro criado com sucesso.'
    else
      flash.now[:erro] = "Erro ao cadastrar. Verifique e tente novamente."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @livro.update(livro_params)
      redirect_to livros_path, notice: "Livro atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @livro.destroy
      redirect_to livros_path, notice: "Livro removido com sucesso!"
    else
      redirect_to livros_path, alert: "Ação bloqueada: Este livro possui histórico de empréstimos e não pode ser excluído."
    end
  end

  private

  def set_livro
    @livro = Livro.find(params[:id])
  end

  def livro_params
    params.require(:livro).permit(:titulo, :autor, :status, :observacoes, :categoria_id)
  end
end