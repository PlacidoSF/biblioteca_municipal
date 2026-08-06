class CategoriasController < ApplicationController
  before_action :require_login

  def index
    @categorias = Categoria.all
  end

  def new 
    @categoria = Categoria.new
  end

  def create
    @categoria = Categoria.new(categoria_parms)

    if @categoria.save
      redirect_to categorias_path, notice: 'Categoria criada com sucesso.'
    else
      flash.now[:erro] = "Erro ao cadastrar. Verifique e tente novamente."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def categoria_parms
    params.require(:categoria).permit(:nome)
  end

end
