SeinfeldCalendar::Application.routes.draw do

  root to: 'pages#root'

  resources :users

end
