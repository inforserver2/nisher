Networks::Application.routes.draw do


  match "/delayed_job" => DelayedJobWeb, :anchor => false
  match "/conferencias" => redirect("http://www.gvolive.com/conference,69094356")

  resources :testes

  match "via/boleto/:id/:token"=>"via#boleto", as: "boleto"
  match "via/boleto_manual/:id/:token"=>"via#boleto_manual", as: "boleto_manual"
  match "via/pagseguro/:id/:token"=>"via#pagseguro", as: "pagseguro"
  match "via/paypal/:id/:token"=>"via#paypal", as: "paypal"
  match "via/saldo/:id/:token"=>"via#saldo", as: "saldo"
  match "via/order/:id/:token"=>"via#order"
  match "via/manual/:id/:token"=>"via#manual"

  resources :news, only: [:create]
  resources :order
  resources :line_items, :only=>[:create, :destroy] do
    put "inc", on: :member
    put "dec", on: :member
  end

  resources :carts, :only=>[:update] do
  end

  match "carrinho" => "carts#show", as: "carrinho"
  match "carrinho/limpar" => "carts#reset", as: "limpar_carrinho"
  match "carrinho/frete_info" => "carts#frete_info", as: "frete_info"
  match "carrinho/address_completed" => "carts#address_completed", as: "address_completed"
  match "carrinho/address_input" => "carts#address_input", as: "address_input"
  match "carrinho/set_frete" => "carts#set_frete", as: "set_frete", via: :post

  match "check_for_name/:name"=>"users#check_for_name", :as=>"check_for_name", :via=>[:get]
  match "check_for_email/"=>"users#check_for_email", :as=>"check_for_email", :via=>[:get]



  resources :fretes
  match "frete/:type"=>"fretes#type", as: "frete_tipo", via: :put
  match "frete/address_copy"=>"fretes#address_copy", as: "address_copy"

  match "site/eventos" => redirect("/pages/1"), :as=>"site_eventos"
  match "renda" => redirect("/site/renda")

  #get "pages/show"

  get "products_more/fillup"
  get "products_more/nutrameal"
  get "products_more/alef"
  get "products_more/mgd"

  get "site/index"
  get "site/about"
  get "site/office_side"
  get "site/office_wide"
  get "site/forms"
  get "site/nisher"
  get "site/renda"
  match "site/prospecto"=>"site#prospecto", as: "prospecto", via: :post

  get "site/depoimentos"
  get "site/dicas"
  get "site/antispam"
  get "site/duvidas"
  get "site/tv"
  get "site/promocoes"
  get "site/cadastro"
  get "site/contrato"

  get "layouts/home"

  get "layouts/content_sidebar"

  get "layouts/content_wide"

  get "layouts/office_sidebar"

  get "layouts/office_wide"

  resources :apps, :only=>[:index]

  resources :products, :only=>[:index,:show] do
    get 'more', :on=>:member
  end
  resources :pages, :only=>[:index,:show]



  resources :contacts, :only=>[:new,:create]

  resources :sessions, :only=>[:new,:create, :destroy]

  resources :users, except: [:index, :destroy, :show, :edit, :update]


  match "sign_in" => "sessions#new", :as=>"sign_in", :via=>:get
  match "sign_in" => "sessions#create", :as=>"sign_in", :via=>:post

  match "sign_out" => "sessions#destroy", :as=>"sign_out", :via=>:get

  match "sign_up" => "users#new", :as=>"sign_up", :via=>:get
  match "sign_up" => "users#create", :as=>"sign_up", :via=>:post


  match "switch/:id/:token" => "users#switch_to_user", :as=>"switch", :via=>:post
  match "return" => "users#return_to_user", :as=>"return", :via=>:post

  match "send_my_password"=>"users#send_my_password", :as=>"send_my_password", :via=>[:get, :post]



  namespace :admin do

    root :to=> redirect("/office")

    get "matrices/index"
    post "matrices/emails"

    resources :jobs, only:[:index,:show]
    match "jobs/run/:id" => "jobs#run", :as=>"jobs_run", :via=>:post


    resources :comms, only:[:index, :show, :edit, :update]
    resources :payments, only:[:index, :show, :edit, :update] do
      put :update_p_bank_account_info, on: :member
      put :close, on: :member
    end
    resources :news, only:[:index, :destroy] do
      put :block, on: :member
      put :unblock, on: :member
      post :emails, on: :collection
    end
    match "news/index"=>"news#index", as:"news_index"
    resources :users, except:[:destroy] do
      post "emails", on: :collection
      get "mass_signup_form", on: :collection
      post "mass_signup_post", on: :collection
      get "users_matrices", on: :collection
    end

    resources :orders do
      post "emails", on: :collection
      put "block_comms", on: :member
    end
    match "orders/close/:id" => "orders#close", :as=>"close_order", :via=>:get
    match "orders/close/:id" => "orders#close_proc", :as=>"close_order", :via=>:put

    resources :fretes, only:[:edit,:update]

    resources :blacklist_usernames, :only=>[:index, :destroy, :new, :create]
    resources :multiusers, :only=>[:index, :destroy, :new, :create]
    resources :products
    resources :product_categories
    resources :boletos
    resources :pages do
      get 'content', :on=>:member
    end
  end

  namespace :office do
    resources :payments, only:[:index, :show]
    match "meus_dados"=>"users#show", as:"meus_dados"

    match "dados_pessoais" => "users#dados_pessoais_form", :as=>"dados_pessoais", :via=>:get
    match "dados_pessoais" => "users#dados_pessoais_proc", :as=>"dados_pessoais", :via=>:put
    match "dados_contato" => "users#dados_contato_form", :as=>"dados_contato", :via=>:get
    match "dados_contato" => "users#dados_contato_proc", :as=>"dados_contato", :via=>:put
    match "minha_senha" => "users#minha_senha_form", :as=>"minha_senha", :via=>:get
    match "minha_senha" => "users#minha_senha_proc", :as=>"minha_senha", :via=>:put
    match "dados_endereco" => "users#dados_endereco_form", :as=>"dados_endereco", :via=>:get
    match "dados_endereco" => "users#dados_endereco_proc", :as=>"dados_endereco", :via=>:put
    match "dados_banco" => "users#dados_banco_form", :as=>"dados_banco", :via=>:get
    match "dados_banco" => "users#dados_banco_proc", :as=>"dados_banco", :via=>:put

    match "networking/activate" => "networking#activate", :as=>"networking_activate", :via=>:get
    match "networking/activated" => "networking#activated", :as=>"networking_activated", :via=>:get
    match "networking/activate" => "networking#activate_proc", :as=>"networking_activate_proc", :via=>:put
    match "networking/stats" => "networking#stats", :as=>"networking_stats", :via=>:get
    match "networking/level/:id" => "networking#level", :as=>"networking_level", :via=>:get
    match "networking/pending" => "networking#pending", :as=>"networking_pending", :via=>:get
    match "networking/clients" => "networking#clients", :as=>"networking_clients", :via=>:get
    match "networking/client/:id" => "networking#client", :as=>"networking_client", :via=>:get
    match "networking/sponsor/:id" => "networking#sponsor", :as=>"networking_sponsor", :via=>:get
    match "networking/matrix/:id" => "networking#show", :as=>"networking_matrix", :via=>:get



    resources :orders, only:[:index]
    resources :comms, only:[:index,:show] do
      collection do
        get "transfer"
        post "transfer_proc"
      end
    end
    root :to=>"office#index"
    get "site/downloads"
    get "site/banners"
    get "site/mensagens"
  end

  match "/:name"=>"users#ident"
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'site#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
