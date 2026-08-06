class CreateBibliotecarios <ActiveRecord::Migration[7.1]
  def change
    create_table :bibliotecarios do |t|
      t.string :nome, null: false
      t.string :email, index: { unique: true }
      t.string :password_digest, null: false
      t.boolean :is_admin, default: false

      t.timestamps
    end
  end
end