Brkit.controllers :user, :provides => [:html] do       
  
  get :settings, :map => '/account-settings' do
    render 'main/account_settings'
  end 
  
  post :update, :map => '/user/update' do
  end      
  
  post :addkey, :map => '/user/key/add' do
    @key = Key.new({:account_id => current_account.id}.merge(params[:key]))
    if @key.save 
      return render 'apiv1/user/key'    
    else 
      status 400     
      @errors = @key.errors 
      render 'apiv1/errors/400'       
    end
  end
end