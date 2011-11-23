Carrie_mongodb::Application.routes.draw do
  resources :learning_objects do
    resources :exercises do
      collection do
        put :update_attribute_on_the_spot
      end
      resources :questions
    end
    collection do
      post :sort_exercises
    end
  end

  root :to => "site#home"
end
