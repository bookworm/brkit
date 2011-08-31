Brkit.controllers :main do   
  
  before do 
    # Remove  
    user = Account.first(:username => 'joe')
    set_current_account(user)         
    @@current_account = user
  end 
  
  get :index, :map => '/' do  
    if current_account
      @activities = current_account.activity_watching_following() 
      @message_count = current_account.message_count
      @myrepos = current_account.repos 
      @watchedrepos = current_account.watched
      render 'main/activity'  
    else
      render 'main/about'
    end
  end
end