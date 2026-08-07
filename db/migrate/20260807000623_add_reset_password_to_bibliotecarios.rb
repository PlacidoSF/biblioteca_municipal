class AddResetPasswordToBibliotecarios < ActiveRecord::Migration[8.1]
  def change
    add_column :bibliotecarios, :reset_password_token, :string
    add_column :bibliotecarios, :reset_password_sent_at, :datetime
  end
end
