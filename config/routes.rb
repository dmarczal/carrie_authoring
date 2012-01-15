Carrie_mongodb::Application.routes.draw do

#  devise_for :users

  post "versions/:id/revert" => "versions#revert", :as => "revert_version"

  resources :learning_objects do
    resources :exercises do
      resources :questions do
        post :validate
      end
      get :show_questions
      collection do
        post :sort_questions
        post :update_fractal_size
      end
    end
    collection do
      post :sort_exercises
    end
  end

  resources :fractals

  root :to => "site#home"
end
