class CategoriasController < ApplicationController
  before_action :set_categoria, only: %i[ edit update destroy ]

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

  def edit
  end

  def update
    if @categoria.update(categoria_parms)
      redirect_to categorias_path, notice: "Categoria atualizada com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @categoria.destroy
      redirect_to categorias_path, notice: "Categoria removida com sucesso!"
    else
      redirect_to categorias_path, alert: "Ação bloqueada: Existem livros cadastrados nesta categoria."
    end
  end

  private

  def set_categoria
    @categoria = Categoria.find(params[:id])
  end

  def categoria_parms
    params.require(:categoria).permit(:nome)
  end
end