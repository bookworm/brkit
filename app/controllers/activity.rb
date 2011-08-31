Brkit.controllers :activity do 
  
  before do
    halt 403, 'Login First' if !current_account    
    if !request.xhr?        
      @message_count = current_account.message_count
      @myrepos = current_account.repos 
      @watchedrepos = current_account.watched
    end
  end   
  
  get :all,  :map => '/activity/all' do   
    @activities = current_account.activity_watching_following() 
    return partial 'activity/activities' if request.xhr?  
    render 'main/activity'
  end
  
  get :on_you, :map => '/activity/on-you' do     
    @activities = current_account.activity_on_user() 
    return partial 'activity/activities' if request.xhr?  
    render 'main/activity'       
  end  
  
  get :by_you, :map => '/activity/by-you' do     
    @activities = current_account.activity() 
    return partial 'activity/activities' if request.xhr?   
    render 'main/activity'
  end  
  
  get :pulls, :map => '/activity/pulls' do
    @activities = current_account.activity({:type => 'pull'}) 
    return partial 'activity/activities' if request.xhr?   
    render 'main/activity'
  end
end