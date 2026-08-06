class AddSenhaProvisoriaToBibliotecarios < ActiveRecord::Migration[7.1]
  def change
    add_column :bibliotecarios, :senha_provisoria, :boolean, default: true
  end
end
