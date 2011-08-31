Issues.controllers :apv1_issues, :provides => [:json] do  
	
	before do   
		@user = Account.first(:username => params[:user])   
		halt 404, 'User Not Found' if !@user
		@repo = Project.first(:author_id => @user.id, :name => params[:repo])
    halt 404, 'Repo Not Found' if !@repo
	end   
	
	before(:search, :repoissues) do
		@options = {}
		if params[:limit] && !params[:limit] > 50  
			@options[:limit] = params[:limit]
		else  
			@options[:limit] = 20
		end
		@options[:skip] = params[:skip] if params[:skip]
	end  
	
	before(:show, :comments, :close, :open, :edit, :labels, :add_label, :delete_label, :comment) do  
		@issue = Issue.first(:project_id => @repo.id, :num_id => params[:numbers])
	end
	
	get :search, '/issues/search/:user/:repo/:search' do 
		@options[:repo_id] = @repo.id
		@issues = Issue.filter(params[:search], @options)   
		return render 'apiv1/issues/list'
	end   
	
	get :repoissues, :map => '/issues/list/:user/:repo' do
		@issues = Issue.all({:repo_id => @repo.id}.merge(@options)) 
		return render 'apiv1/issues/list'
	end   
	
	get :show, :map => '/issues/show/:user/:repo/:number' do
		return render 'apiv1/issues/show'
	end  
	
	get :comments, :map => '/issues/comments/:user/:repo/:number' do 
		@comments = @issue.comments 
		return render 'apiv1/issues/comments'
	end      
	
	get :new, :map => '/issues/open/:user/:repo' do
		@issue = @repo.add_issue(params[:issue]) 
	  if @issue.save 
			return render 'apiv1/issues/show'   
		else 
			status 400     
			@errors = @issue.errors
			render 'apiv1/errors/400'      
		end
	end    
	
	get :close, :map => '/issues/close/:user/:repo/:number' do           
		@issue.close
	  if @issue.errors.length == 0
			return render 'apiv1/issues/show'   
		else 
			status 400     
			@errors = @issue.errors
			render 'apiv1/errors/400'      
		end
	end 
 
	get :open, :map => '/issues/reopen/:user/:repo/:number' do 
		@issue.open
	  if @issue.errors.length == 0
			return render 'apiv1/issues/show'   
		else 
			status 400     
			@errors = @issue.errors
			render 'apiv1/errors/400'      
		end
	end 
	
	post :edit, :map => '/issues/edit/:user/:repo/:number' do 
		if @issue.update_attributes(params[:issue])
			return render 'apiv1/issues/show'   
		else 
			status 400     
			@errors = @issue.errors
			render 'apiv1/errors/400'      
		end
	end 
	
	get :labels, :map => '/issues/labels/:user/:repo' do   
		@labels = Issue.labels({:project_id => @repo.id})   
		return @labels.to_json   
	end    
	
	post :add_label, :map => '/issues/label/add/:user/:repo/:label/:number' do  
		@issue.labels << params[:label]    
		@labels = @issue.labels 
		if @issue.save 
			return @labels.to_json   
		else 
			status 400     
			@errors = @issue.errors
			render 'apiv1/errors/400'      
		end
	end  
	
	delete :delete_label, :map => '/issues/label/remove/:user/:repo/:label/:number' do   
		@issue.labels.delete(params[:label])      
		if @issue.save 
		  return @labels.to_json   
		else 
			status 400     
			@errors = @issue.errors
			render 'apiv1/errors/400'      
		end
	end   
	
	post :comment, :map => '/issues/comment/:user/:repo/:number' do
		@comment = @issue.add_comment(params[:comment])
		if @comment.save  
			return render 'apiv1/issues/show'   
		else 
			status 400     
			@errors = @issue.errors
			render 'apiv1/errors/400'      
		end   
	end
end