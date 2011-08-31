# Repo internally is actually a Git Repo. Project models are a further abstraction of a repo. 
# This is because Gists can have repos as well.
Brkit.controllers :repos, :provides => [:html] do      
  
  before do
    halt 403, 'Login First' if !current_account    
    if !request.xhr?        
      @message_count = current_account.message_count
      @myrepos = current_account.repos 
      @watchedrepos = current_account.watched
    end
  end   
  
  before(:show) do          
		@user = Account.first(:username => params[:user])   
		halt 404, 'User Not Found' if !@user
		@repo = Project.first(:author_id => @user.id, :name => params[:repo])
    halt 404, 'Repo Not Found' if !@repo
	end

  get :new, :map => '/repos/new' do
    render 'repos/new'
  end   
  
  post :create, :map => '/repos/create' do  
		@repo = Project.new({:author_id => current_account.id}.merge(params[:repo]))
		if @repo.save
			redirect @repo.url
		else 
			render 'repos/new'
		end
	end  
	
	get :show, :map => '/:user/:repo' do      
    return render 'repos/show'
  end    
end