class SessionsController < ApplicationController

  skip_before_action :require_login, only: [:new, :create, :destroy]
  skip_before_action :verificar_senha_provisoria, only: [:new, :create, :destroy]
  def new
    
  end

  def create
    
    bibliotecario = Bibliotecario.find_by(email: params[:email])

    if bibliotecario && bibliotecario.authenticate(params[:senha])
      session[:bibliotecario_id] = bibliotecario.id

      if bibliotecario.senha_provisoria
        redirect_to redefinir_senha_path
      else
        redirect_to bibliotecarios_path, notice: "Login realizado com sucesso! Bem-vindo(a), #{bibliotecario.nome}."
      end

    else 
      flash.now[:erro] = 'Email ou senha inválidos.'
      render :new, status: :unprocessable_entity
    end

  end

  def destroy
    session[:bibliotecario_id] = nil
    redirect_to login_path, notice: 'Sessão encerrada.'
  end
end
