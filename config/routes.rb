Rails.application.routes.draw do

  devise_for :bibliotecarios, path: 'auth', controllers: {
    registrations: 'bibliotecarios/registrations',
    passwords: 'bibliotecarios/passwords'
  }
  
  # bibliotecarios
  resources :bibliotecarios, only: [:index, :new, :create]
  
  # categorias 
  resources :categorias, only: [:index, :new, :create]

  # livros
  resources :livros, only: [:index, :new, :create]

  # usuarios
  resources :usuarios, only: [:index, :new, :create]

  # emprestimos
  resources :emprestimos, only: [:index, :new, :create, :show] do
    member do
      patch :finalizar
    end
  end

  root "emprestimos#index"
end
