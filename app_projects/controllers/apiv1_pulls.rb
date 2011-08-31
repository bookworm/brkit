Projects.controllers :apv1_pulls, :provides => [:json] do 
	
	before(:create, :pulls, :show) do    
		@user = Account.first(:username => params[:user])   
		halt 404, 'User Not Found' if !@user
		@repo = Project.first(:author_id => @user.id, :name => params[:repo])
    halt 404, 'Repo Not Found' if !@repo
	end  
	
	post :create, :map => '/pulls/:user/:repo' do    
		@pull = @repo.add_pull(params[:pull])     
		if @pull.save
			return render 'apiv1/pulls/show'   
		else 
			status 400     
			@errors = @pull.errors 
			render 'apiv1/errors/400'      
		end
	end    
	
	get :pulls, :map => '/pulls/:user/:repo/:state' do  
		@pulls = @repo.pulls(params[:state])   
		return render 'apiv1/pulls/list'   
	end     
	
	get :show, :map => '/pulls/:user/:repo/:number' do     
		@pull = Pull.first(:to_project_id => @repo.id, :num_id => params[:number])    
		return render 'apiv1/pulls/show'   
	end
end