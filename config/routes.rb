Carrie_mongodb::Application.routes.draw do
  resources :learning_objects do
    resources :exercises do
      resources :questions
    end
  end

  root :to => "site#home"
end
