class Bibliotecarios::PasswordsController < Devise::PasswordsController
  def update
    super do |resource|
      if resource.errors.empty?
        resource.update_column(:senha_provisoria, false)
      end
    end
  end
end