Users.controllers :apv1_user, :provides => [:json] do 
                                                       
  # Lets Build up our options.
  before(:search) do  
    @options = {}
    if params[:limit] && !params[:limit] > 50  
      @options[:limit] = params[:limit]
    else  
      @options[:limit] = 20
    end
    @options[:skip] = params[:skip] if params[:skip]
  end      
   
  # Get The User.
  before(:show, :edit, :following, :followers, :watched) do     
    @user = Account.first(:username => params[:username])
    halt 404, 'User Not Found' if !@user           
    @current_account = current_account       
    @authenticated = false
    @authenticated = true if @current_account.id == @user.id
  end     
  
  before(:keys, :addkey, :removekey) do
    halt 403, 'Login To Use These Features' if !current_account
  end    
  
  get :search, :map => '/api/v1/user/search/:search' do  
    @users = Account.all({:username => /^#{params[:search]}.*/i}.merge(@options))
    return render 'apiv1/user/search'  
  end

  get :show, :map => '/api/v1/user/show/:username' do     
    return render 'apiv1/user/show'       
  end    
  
  post :edit, :map => '/api/v1/user/show/:username' do    
    halt 403, 'Not your user?' if @user.id != current_account.id      
    if @user.update_attributes(params[:user])     
      return render 'apiv1/user/show'
    else 
      status 400     
      @errors = @user.errors
      render 'apiv1/errors/400'   
    end
  end  

  get :following, :map => '/api/v1/user/show/:username/following' do            
    @user.following.to_json   
  end   
   
  get :followers, :map => '/api/v1/user/show/:username/followers' do 
    @user.followers.to_json         
  end       
  
  get :watched, :map => '/api/v1/user/show/:username/watched' do  
    @repos = @user.watched    
    return render 'apiv1/user/watched'       
  end 
  
  get :keys, :map => '/api/v1/user/keys' do     
    @keys = current_account.get_keys
    return render 'apiv1/user/keys'       
  end    
  
  post :addkey, :map => '/api/v1/user/key/add' do
    @key = Key.new({:account_id => current_account.id}.merge(params[:key]))
    if @key.save 
      return render 'apiv1/user/key'    
    else 
      status 400     
      @errors = @key.errors 
      render 'apiv1/errors/400'       
    end
  end   
  
  post :removekey, :map => '/api/v1/user/key/remove' do   
    @key = Key.first(:account_id => current_account.id, :name => params[:name]) 
    if @key.delete
      status 200
    else 
      status 400    
      @errors = @key.errors
      render 'apiv1/errors/400'       
    end
  end 
end  