Carrie_mongodb::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  resources :learning_groups do
    get :matriculate_user
    get :matriculate
  end

  devise_for :users, :controllers => {:registrations => "registrations"}

  post "versions/:id/revert" => "versions#revert", :as => "revert_version"


  resources :learning_objects do
    resources :introductions
    resources :exercises do
      resources :questions do
        post :validate
      end
      get :show_questions
      collection do
        get :show_help_question
        post :sort_questions
        post :update_fractal_size
      end
    end
    collection do
      post :sort_exercises
      post :sort_introductions
    end
  end

  namespace :published do
    resources :fractals do
       get ':id/page/:page', :action => :show, :on => :collection
    end
  end

  resources :fractals

  root :to => "site#home"
end
