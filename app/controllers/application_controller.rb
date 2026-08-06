class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :verificar_senha_provisoria

  helper_method :current_bibliotecario

  private 

  def current_bibliotecario
    if session[:bibliotecario_id]
      @current_bibliotecario ||= Bibliotecario.find_by(id: session[:bibliotecario_id])
    end
  end

  def require_login
    unless current_bibliotecario
      flash[:erro] = "Você precisa fazer login para acessar o sistema."
      redirect_to login_path
    end
  end

  def verificar_senha_provisoria
    if current_bibliotecario && current_bibliotecario.senha_provisoria
      flash[:alert] = "Você precisa alterar sua senha provisória antes de continuar."
      redirect_to redefinir_senha_path
    end
  end

  def require_admin
    unless current_bibliotecario && current_bibliotecario.is_admin
      flash[:erro] = "Acesso negado. Você não tem permissão para acessar esta página."
      redirect_to login_path
    end
  end
end
