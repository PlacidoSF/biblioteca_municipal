class UsuariosController < ApplicationController
  before_action :set_usuario, only: %i[ show edit update destroy ]

  def index 
    @usuarios = Usuario.all
  end

  def new 
    @usuario = Usuario.new
  end

  def show
    @emprestimos = @usuario.emprestimos.includes(:livro).order(created_at: :desc)
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

  def edit
  end

  def update
    if @usuario.update(usuario_params)
      redirect_to usuarios_path, notice: "Usuário atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @usuario.destroy
      redirect_to usuarios_path, notice: "Usuário removido com sucesso!"
    else
      
      redirect_to usuarios_path, alert: "Ação bloqueada: Este usuário possui histórico de empréstimos e não pode ser excluído."
    end
  end

  private

  def set_usuario
    @usuario = Usuario.find(params[:id])
  end

  def usuario_params
    params.require(:usuario).permit(:nome, :cpf, :telefone, :email)
  end
end