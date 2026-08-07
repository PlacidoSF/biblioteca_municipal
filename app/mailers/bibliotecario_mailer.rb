class BibliotecarioMailer < ApplicationMailer
  default from: 'biblioteca.desafio.placido@gmail.com'

  def recuperar_senha_email(bibliotecario)
    @bibliotecario = bibliotecario

    mail(to: @bibliotecario.email, subject: 'Recuperação de Senha - Sistema da Biblioteca')
  end
end
