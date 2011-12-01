Carrie_mongodb::Application.routes.draw do
  resources :learning_objects do
    resources :exercises do
      resources :questions
      collection do
        put :update_attribute_on_the_spot
      end
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
