Carrie_mongodb::Application.routes.draw do

  get "help/index"

  mount Ckeditor::Engine => '/ckeditor'

  resources :learning_groups do
    post :enroll
    get 'my_groups', action: :my_groups, :on => :collection
    get 'my_group', action: :my_group, :on => :member
    get 'all_groups', action: :all_groups, :on => :collection
  end

  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}

  resources :learning_objects do
    resources :introductions
    resources :exercises do
      resources :questions do
        post :verify_answer
        post :verify_and_save_answer
      end
      get :show_questions
      collection do
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
       get ':id/page/:page', action: :show, :on => :collection
       get  :preview, :on => :member
       get 'preview/page/:page', :action => :preview, :on => :member
    end
  end

  resources :fractals

  root :to => "site#home"
end
