class LivrosController < ApplicationController
  
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

  private

  def livro_params
    params.require(:livro).permit(:titulo, :autor, :status, :observacoes, :categoria_id)
  end
end
