Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'api/v1/notes', to: 'note#get_notes'
  put 'api/v1/notes', to: 'note#post_note'
  put 'api/v1/users', to: 'user#new_user'
  post 'api/v1/users', to: 'user#login_user'
  delete 'api/v1/users', to: "user#logout_user"
end
