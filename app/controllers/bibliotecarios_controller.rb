class BibliotecariosController < ApplicationController
  before_action :require_admin

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

  private
  
  def bibliotecario_params
    params.require(:bibliotecario).permit(:nome, :email, :password, :password_confirmation)
  end
end
