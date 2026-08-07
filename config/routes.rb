Rails.application.routes.draw do
  get "recuperacao_senhas/new"
  get "recuperacao_senhas/edit"

  # login
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # redefinir senha
  get 'redefinir_senha', to: 'senhas#edit'
  patch 'redefinir_senha', to: 'senhas#update'

  # bibliotecarios
  resources :bibliotecarios, only: [:index, :new, :create]
  
  # categorias 
  resources :categorias, only: [:index, :new, :create]

  # livros
  resources :livros, only: [:index, :new, :create]

  # usuarios
  resources :usuarios, only: [:index, :new, :create]

  # recuperar senha
  resources :recuperacao_senhas, only: [:new, :create, :edit, :update]
end
