class BibliotecariosController < ApplicationController
  before_action :require_admin
  before_action :set_bibliotecario, only: %i[ edit update destroy ]

  def index
    @bibliotecarios = Bibliotecario.where(is_admin: false)
  end

  def new
    @bibliotecario = Bibliotecario.new
  end

  def create
    @bibliotecario = Bibliotecario.new(bibliotecario_params)

    @bibliotecario.is_admin = false
    @bibliotecario.senha_provisoria = true

    if @bibliotecario.save
      redirect_to bibliotecarios_path, notice: 'Bibliotecário criado com sucesso.'

    else
      flash.now[:erro] = "Erro ao cadastrar. Verifique e tente novamente."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    
    if @bibliotecario.update(bibliotecario_params)
      redirect_to bibliotecarios_path, notice: "Bibliotecário atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bibliotecario.destroy
    redirect_to bibliotecarios_path, notice: "Bibliotecário removido com sucesso!"
  end

  private
  def set_bibliotecario
    @bibliotecario = Bibliotecario.find(params[:id])
  end

  def bibliotecario_params
    params.require(:bibliotecario).permit(:nome, :email, :password, :password_confirmation)
  end
end
