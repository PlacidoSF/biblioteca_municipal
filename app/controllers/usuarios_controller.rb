class UsuariosController < ApplicationController

  def index 
    @usuarios = Usuario.all
  end

  def new 
    @usuario = Usuario.new
  end

  def create
    @usuario = Usuario.new(usuario_params)
    if @usuario.save
      UsuarioMailer.bem_vindo(@usuario).deliver_now
      redirect_to usuarios_path, notice: "Usuário criado com sucesso."
    else
      flash.now[:erro] = "Erro ao criar usuário. Verifique os campos e tente novamente."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def usuario_params
    params.require(:usuario).permit(:nome, :cpf, :telefone, :email)
  end
end
