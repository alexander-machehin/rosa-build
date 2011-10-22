Rosa::Application.routes.draw do
  devise_for :users, :controllers => {:omniauth_callbacks => 'users/omniauth_callbacks'} do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end
  resources :users
  
  resources :roles

  resources :event_logs, :only => :index

  resources :downloads, :only => :index

  resources :categories do
    get :platforms, :on => :collection
  end

  match '/private/:platform_name/*file_path' => 'privates#show'

  resources :platforms do
    resources :private_users

    member do
      get 'freeze'
      get 'unfreeze'
      get 'clone'
    end

    resources :products do
      member do
        get :clone
        get :build
      end
    end

    resources :repositories do
    end

    resources :categories, :only => [:index, :show]
  end

  resources :projects do
    resources :build_lists, :only => [:index, :show] do
      collection do
        get :recent
        post :filter
      end
      member do
        post :publish
      end
    end
  end

  resources :repositories do
    member do
      get :add_project
      get :remove_project
    end
  end

  resources :users, :groups do
    resources :platforms, :only => [:new, :create]

    resources :projects, :only => [:new, :create]

    resources :repositories, :only => [:new, :create]
  end

  match 'build_lists/status_build', :to => "build_lists#status_build"
  match 'build_lists/post_build', :to => "build_lists#post_build"
  match 'build_lists/pre_build', :to => "build_lists#pre_build"
  match 'build_lists/circle_build', :to => "build_lists#circle_build"
  match 'build_lists/new_bbdt', :to => "build_lists#new_bbdt"

  match 'product_status', :to => 'products#product_status'

  # Tree
  match 'platforms/:platform_id/repositories/:repository_id/projects/:project_id/git/tree/:treeish(/*path)', :controller => "git/trees", :action => :show, :treeish => /[0-9a-zA-Z_.\-]*/, :defaults => { :treeish => :master }, :as => :tree

  # Commits
  match 'platforms/:platform_id/repositories/:repository_id/projects/:project_id/git/commits/:treeish(/*path)', :controller => "git/commits", :action => :index, :treeish => /[0-9a-zA-Z_.\-]*/, :defaults => { :treeish => :master }, :as => :commits
  match 'platforms/:platform_id/repositories/:repository_id/projects/:project_id/git/commit/:id(.:format)', :controller => "git/commits", :action => :show, :defaults => { :format => :html }, :as => :commit

  # Blobs
  match 'platforms/:platform_id/repositories/:repository_id/projects/:project_id/git/blob/:treeish/*path', :controller => "git/blobs", :action => :show, :treeish => /[0-9a-zA-Z_.\-]*/, :defaults => { :treeish => :master }, :as => :blob
  match 'platforms/:platform_id/repositories/:repository_id/projects/:project_id/git/commit/blob/:commit_hash/*path', :controller => "git/blobs", :action => :show, :platform_name => /[0-9a-zA-Z_.\-]*/, :project_name => /[0-9a-zA-Z_.\-]*/, :as => :blob_commit

  # Blame
  match 'platforms/:platform_id/repositories/:repository_id/projects/:project_id/git/blame/:treeish/*path', :controller => "git/blobs", :action => :blame, :treeish => /[0-9a-zA-Z_.\-]*/, :defaults => { :treeish => :master }, :as => :blame
  match 'platforms/:platform_id/repositories/:repository_id/projects/:project_id/git/commit/blame/:commit_hash/*path', :controller => "git/blobs", :action => :blame, :as => :blame_commit

  # Raw
  match 'platforms/:platform_id/repositories/:repository_id/projects/:project_id/git/raw/:treeish/*path', :controller => "git/blobs", :action => :raw, :treeish => /[0-9a-zA-Z_.\-]*/, :defaults => { :treeish => :master }, :as => :raw
  match 'platforms/:platform_id/repositories/:repository_id/projects/:project_id/git/commit/raw/:commit_hash/*path', :controller => "git/blobs", :action => :raw, :as => :raw_commit

  root :to => "platforms#index"
end
