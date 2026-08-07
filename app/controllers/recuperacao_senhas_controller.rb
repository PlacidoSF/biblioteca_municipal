class RecuperacaoSenhasController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :edit, :update], raise: false
  
  def new
  end

  def create
    @bibliotecario = Bibliotecario.find_by(email: params[:email])
  
    if @bibliotecario
      @bibliotecario.gerar_token_recuperacao

      BibliotecarioMailer.recuperar_senha_email(@bibliotecario).deliver_now
  
    end

    redirect_to login_path, notice: "Se o e-mail estiver cadastrado, você receberá um link de recuperação em instantes."
  end

  def edit

    @bibliotecario = Bibliotecario.find_by(reset_password_token: params[:id]) 

    if @bibliotecario.nil?
      redirect_to new_recuperacao_senha_path, notice: "Link inválido ou expirado."
    end
  end

  def update

    @bibliotecario = Bibliotecario.find_by(reset_password_token: params[:id]) 

    if @bibliotecario.update(senha_params)
      @bibliotecario.update_columns(reset_password_token: nil, reset_password_sent_at: nil)

      redirect_to login_path, notice: "Senha atualizada com sucesso! Você já pode fazer login."
    else
      flash.now[:erro] = "Erro ao atualizar a senha. Verifique os dados."
      render :edit, status: :unprocessable_entity
    end
  end


  private 

  def senha_params
    params.require(:bibliotecario).permit(:password, :password_confirmation)
  end
end
