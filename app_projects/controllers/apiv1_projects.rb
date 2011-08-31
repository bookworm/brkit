# Repo internally is actually a Git Repo. Project models are a further abstraction of a repo. 
# This is because Gists can have repos as well.
Projects.controllers :apiv1_repos, :provides => [:json] do             
	
	before(:search, :all) do
		@options = {}
		if params[:limit] && !params[:limit] > 50  
			@options[:limit] = params[:limit]
		else  
			@options[:limit] = 20
		end
		@options[:skip] = params[:skip] if params[:skip]
	end 
	
	# Get The User & User.    
	before(:show, :edit, :unwatch, :watch, :fork) do   
		@user = Account.first(:username => params[:user])   
		halt 404, 'User Not Found' if !@user
		@repo = Project.first(:author_id => @user.id, :name => params[:repo])
    halt 404, 'Repo Not Found' if !@repo
	end      
	
  get :search, :map => '/repos/search/:search' do    
		@repos = Project.filter(params[:search], @options)   
		return render 'apiv1/repos/list'      
  end  

	get :show, :map => '/repos/show/:user/:repo' do 
		return render 'apiv1/repos/show'      
	end    
	
	post :edit, :map => '/repos/show/:user/:repo' do
		halt 403, 'Not your user?' if @user.id != current_account.id      
		if @repo.update_attributes(params[:repo])     
			return render 'apiv1/repos/show'   
		else 
			status 400           
			@errors = @repo.errors
			render 'apiv1/errors/400'      
		end
	end     
	
	get :all, :map => '/repos/show/:user' do
		@repos = Project.all({:author_id => @user.id}.merge(@options))   
		return render 'apiv1/repos/list'
	end      
	
	get :unwatch, :map => '/repos/unwatch/:user/:repo' do
		if current_account.unwatch(@repo)    
			return status 200
		else 
			status 400
			render 'apiv1/errors/400'      
		end
	end 
	
	get :watch, :map => '/repos/unwatch/:user/:repo' do       
		if current_account.watch(@repo)         
			return status 200   
		else 
			status 400 
			render 'apiv1/errors/400'      
		end
	end   
	
	get :fork, :map => '/repos/fork/:user/:repo' do   
	  @fork = @repo.fork()
		if @fork.errors.length == 0 
			return render 'apiv1/repos/fork'   
		else 
			status 400   
			@errors = @fork.errors
			render 'apiv1/errors/400'      
		end 
	end    
	
	post :create, :map => '/repos/create' do  
		@repo = Project.new({:author_id => current_account.id}.merge(params[:repo]))
		if @repo.save
			return render 'apiv1/repos/show'   
		else 
			status 400   
			@errors = @repo.errors
			render 'apiv1/errors/400'      
		end
	end      
	
	post :delete, :map => '/repos/:user/delete/:repo' do 
		@repo = Project.first(:author_id => current_account.id, :name => params[:repo])
		if @repo.destroy
			return status 200  
		else 
			status 400   
			@errors = @repo.errors
			render 'apiv1/errors/400'      
		end
	end       
	
	post :private, :map => '/repos/set/private/:user/:repo' do    
		if @repo.make_private
			return status 200
		else 
			status 400   
			@errors = @repo.errors
			render 'apiv1/errors/400'      
		end      
	end     
	
	post :public, :map => '/repos/set/private/:user/:repo' do    
		if @repo.make_public
			return status 200   
		else 
			status 400   
			@errors = @repo.errors
			render 'apiv1/errors/400'      
		end      
	end      
	
	get :keys, :map => '/repos/keys/:user/:repo' do   
		@keys = @repo.get_keys(@user)   
		return render 'apiv1/repos/keys'   
	end    
	
	post :key,  :map => '/repos/key/:user/:repo/add' do   
		@key = @repo.add_key(params[:key])
		if @key.save
			return render 'apiv1/repos/key'   
		else  
			status 400   
			@errors = @key.errors
			render 'apiv1/errors/400'
		end
	end   
	
	post :removekey, :map => '/repos/key/:user/:repo/remove/:keyid' do   
		@key = Key.first(:id => params[:keyid])  
		if @key.delete 
			return status 200 
		else  
			status 400   
			@errors = @key.errors
			render 'apiv1/errors/400'
		end 
	end  
	
	get :collabs, :map => '/repos/show/:user/:repo/collaborators' do
		@users = @repo.collaborators
		return render 'apiv1/repos/users'   
	end  
	
	post :addcollab, :map => '/repos/collaborators/:user/:repo/add/:collaborator' do   
		if @repo.add_collaborator(params[:collaborator])
			return status 200
		else
			status 400   
			@errors = @repo.errors
			render 'apiv1/errors/400'	
		end    
	end  
	
	post :removecollab, :map => '/repos/collaborators/:user/:repo/remove/:collaborator' do   
		if @repo.remove_collaborator(params[:collaborator])
			return status 200  
		else
			status 400   
			@errors = @repo.errors
			render 'apiv1/errors/400'	
		end    
	end   
	
	get :pushable, :map => '/repos/pushable' do
		@repos = @user.pushable   
		return render 'apiv1/repos/list'    
	end   
	
	get :contributors, :map => '/repos/show/:user/:repo/contributors' do
		@users = @repo.contributors  
		return render 'apiv1/repos/users'     
	end    
	
	get :watchers, :map => '/repos/show/:user/:repo/watchers' do         
		@users = @repo.watchers
		return render 'apiv1/repos/users'
	end   
	
	get :tags, :map => '/repos/show/:user/:repo/tags' do     
		@repo.repo.tag.to_json
	end     
	
	get :branches, :map => '/repos/show/:user/:repo/branches' do     
		@repo.repo.branches.to_json
	end
end