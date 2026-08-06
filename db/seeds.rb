# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Bibliotecario.find_or_create_by!( email: 'admin' ) do |admin|
  admin.nome = 'Administrador'
  admin.email = 'admin'
  admin.password = 'admin'
  admin.is_admin = true
  admin.senha_provisoria = false
end 

Bibliotecario.create!(
  nome: 'Plácido',
  email: 'placido@example.com',
  password: '123456',
  is_admin: false,
  senha_provisoria: true
)