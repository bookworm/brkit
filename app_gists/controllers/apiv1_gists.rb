Gists.controllers :gists, :provides => [:json] do      
	
	before(:show, :edit, :delete, :star, :fork) do 
		@gist = Gist.first(:slug => params[:slug])
	  halt 404, 'Gist Not Found' if !@gist      
	end
	
	get :gists, :map => '/users/:user/gists' do
		@gists = @user.gists
		return render 'apiv1/gists/list'   
	end     
	
	get :starred, :map => '/users/:user/gists/starred' do  
		@gists = @user.gists({:starred => true})
		return render 'apiv1/gists/list'   
	end      
	
	get :show, :map => '/gists/:slug' do
		return render 'apiv1/gists/show'   
	end      
	
	post :create, :map => '/gists' do         
		@gist = Gist.new({:author_id => current_account.id}.merge(params[:gist])) 
		if @gist.save
			return render 'apiv1/gists/show'   
		else 
			status 400   
			@errors = @gist.errors
			render 'apiv1/errors/400'      
		end
	end     
	
	put :edit, :map => '/gists/:slug' do 
		if @gist.update_attributes(params[:gist])
			return render 'apiv1/gists/show'   
		else 
			status 400   
			@errors = @gist.errors
			render 'apiv1/errors/400'      
		end
	end   
	
	delete :delete, :map => '/gists/:slug' do 
		if @gist.delete
			return status 200 
		else 
			status 400   
			@errors = @gist.errors
			render 'apiv1/errors/400'      
		end
	end
	
	post :star, :map => '/gists/:slug/star' do
		@gist.star
		if @gist.save
			return render 'apiv1/gists/show'   
		else 
			status 400   
			@errors = @gist.errors
			render 'apiv1/errors/400'      
		end
	end   
	
	delete :unstar, :map => '/gists/:slug/unstar' do
		@gist.unstar
		if @gist.save
			return render 'apiv1/gists/show'   
		else 
			status 400   
			@errors = @gist.errors
			render 'apiv1/errors/400'      
		end
	end   
	
	post :fork, :map => '/gists/:slug/fork' do
		@fork = @gist.fork
		if @fork.errors.length == 0
			return render 'apiv1/gists/fork'   
		else 
			status 400   
			@errors = @fork.errors
			render 'apiv1/errors/400'      
		end
	end
end