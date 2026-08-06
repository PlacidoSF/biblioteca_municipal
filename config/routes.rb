Rails.application.routes.draw do

  # login
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # redefinir senha
  get 'redefinir_senha', to: 'senhas#edit'
  patch 'redefinir_senha', to: 'senhas#update'

  # bibliotecarios
  resources :bibliotecarios, only: [:index, :new, :create] 
end
