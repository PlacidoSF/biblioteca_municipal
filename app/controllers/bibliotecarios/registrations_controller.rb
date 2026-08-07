class Bibliotecarios::RegistrationsController < Devise::RegistrationsController
  protected

  def update_resource(resource, params)
    if resource.update_with_password(params)
      resource.update_column(:senha_provisoria, false)
      true
    else
      false
    end
  end

  def after_update_path_for(resource)
    livros_path
  end
end