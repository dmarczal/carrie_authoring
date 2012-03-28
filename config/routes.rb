Carrie_mongodb::Application.routes.draw do

  get "help/index"
  match "answers/learning_object/:id/errors" => "answers#errors", as: "learning_objects_current_user_errors"
  match "answers/user_errors/:id/learning_objects/:learning_object_id" => "answers#user_errors",
        as: "user_learning_object_errors"

  mount Ckeditor::Engine => '/ckeditor'

  resources :learning_groups do
    post :enroll
    get 'my_groups', action: :my_groups, :on => :collection
    get 'my_group', action: :my_group, :on => :member
    get 'my_group/learning_object/:learning_object',
        action: :learning_object, :on => :member, as: 'learning_object'
    get 'all_groups', action: :all_groups, :on => :collection
    get 'user/:user_id', action: :user, :on => :member, as: 'user'
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
