Rails.application.routes.draw do

  devise_for :bibliotecarios, path: 'auth', controllers: {
    registrations: 'bibliotecarios/registrations',
    passwords: 'bibliotecarios/passwords'
  }
  
  # bibliotecarios
  resources :bibliotecarios, only: [:index, :new, :create, :edit, :update, :destroy]
  
  # categorias 
  resources :categorias, only: [:index, :new, :create , :edit, :update, :destroy]

  # livros
  resources :livros, only: [:index, :new, :create, :edit, :update, :destroy]

  # usuarios
  resources :usuarios, only: [:index, :new, :create, :show, :edit, :update, :destroy]

  # emprestimos
  resources :emprestimos, only: [:index, :new, :create, :show] do

    collection do
      get :relatorio_atrasos
    end
    
    member do
      patch :finalizar
    end
  end

  root "emprestimos#index"
end
