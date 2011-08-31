Users.controllers :sessions, :provides => [:html] do        
  
  get :logout, :map => '/logout' do  
    set_current_account(nil)
    redirect '/'
  end
end