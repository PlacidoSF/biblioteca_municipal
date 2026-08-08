class ApplicationController < ActionController::Base
  before_action :authenticate_bibliotecario!
  before_action :verificar_senha_provisoria

  def after_sign_in_path_for(resource)
    emprestimos_path
  end

  def after_sign_out_path_for(resource_or_scope)
    flash.delete(:notice)
    new_bibliotecario_session_path
  end

  private 

  def verificar_senha_provisoria
    if current_bibliotecario && (current_bibliotecario.senha_provisoria == true || current_bibliotecario.senha_provisoria == 1)
      return if devise_controller?
      flash[:alert] = "Você precisa alterar sua senha provisória antes de continuar."
      redirect_to edit_bibliotecario_registration_path
    end
  end

  def require_admin
    is_admin = current_bibliotecario && (current_bibliotecario.is_admin == true || current_bibliotecario.is_admin == 1)
    
    unless is_admin

      sign_out current_bibliotecario if current_bibliotecario
      
      flash[:erro] = "Acesso negado. Sua sessão foi encerrada por medida de segurança."
      redirect_to new_bibliotecario_session_path
    end
  end
end