class SenhasController < ApplicationController
  before_action :require_login

  skip_before_action :verificar_senha_provisoria

  def edit
    
  end

  def update
    
    if params[:senha] == params[:confirmacao_senha]
      
      if current_bibliotecario.update(password: params[:senha], senha_provisoria: false)
        redirect_to root_path, notice: "Senha atualizada com sucesso! Bem-vindo(a)." 
      
      else
        flash.now[:erro] = "Ocorreu um erro ao salvar a sua senha."
        render :edit, status: :unprocessable_entity
      end

    else
      flash.now[:erro] = "As senhas digitadas não coincidem."
      render :edit, status: :unprocessable_entity
    end
  end
end
