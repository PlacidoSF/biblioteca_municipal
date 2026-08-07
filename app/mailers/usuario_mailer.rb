class UsuarioMailer < ApplicationMailer
  default from: 'biblioteca.desafio.placido@gmail.com'

  def bem_vindo(usuario)
    @usuario = usuario

    mail(to: @usuario.email, subject: 'Bem-vindo à Biblioteca Desafio Plácido')
  end
end
