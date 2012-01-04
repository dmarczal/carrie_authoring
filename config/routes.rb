Carrie_mongodb::Application.routes.draw do

  post "versions/:id/revert" => "versions#revert", :as => "revert_version"

  resources :learning_objects do
    resources :exercises do
      resources :questions
    end
    collection do
      post :sort_exercises
    end
  end

  resources :fractals do
    collection do
      post :update_size
    end
  end

  root :to => "site#home"
end
