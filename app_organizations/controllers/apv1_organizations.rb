Organizations.controllers :apiv1_organizations, :provides => [:json] do 
	
	before(:show, :public_repos, :team) do
		@org = Organization.first(:name => params[:org]) 
		halt 404, 'Organization Not Found' if !@org
	end      
	
	before(:team, :updateteam, :deleteteam, :team_members, :add_team_member, :delete_team_member, :team_repos, :add_team_repo, :delete_team_repo) do
		@team = Team.first(:organization_id => @org.id, :name => param[:team_name])
		halt 404, 'Team Not Found' if !@team
	end       
	
	before(:add_team_member, :delete_team_member) do
		@user = User.first(:username => params[:username])
		halt 404, 'User Not Found' if !@user
	end  
	
	before(:add_team_repo, :delete_team_repo) do
		@repo = Project.first(:author_id => current_account.id, :name => params[:repo], :organization_id => @org.id)
		halt 404, 'Repo Not Found' if !@repo	
	end 
	
	before(:my_orgs, :repos) do
	  halt 403, 'No Access' if !current_account
  end
	
	get :show, :map => '/organizations/:org' do  
		return render 'apiv1/organizations/show'      
	end     
	
	put :create, :map => '/organizations/:org' do     
		@org = Organization.new(params[:org])        
		if @org.save 
		 	return render 'apiv1/organizations/show'       
		else 
			status 400     
			@errors = @org.errors 
			render 'apiv1/errors/400'      
		end
	end   
	
	get :orgs, :map => '/user/show/:user/organizations' do
		@user = User.first(:username => params[:user])  
		halt 404, 'User Not Found' if !@user   
		@organizations = @user.organizations
		return render 'apiv1/organizations/list'      
	end   
	
	get :my_orgs, :map => '/organizations' do
		@organizations = current_account.organizations
		return render 'apiv1/organizations/list'      
	end       
	
	get :repos, :map => '/organizations/repositories' do
		@repos = current_account.organization_repos
		return render 'apiv1/organizations/repos'      
	end     
	
 	get :public_repos, :map => '/organizations/:org/public_repositories' do
		@repos = @org.repos({:private => false})
		return render 'apiv1/organizations/repos'      
	end  
	
	get :members, :map => '/organizations/:org/members' do 
		@members = @org.members
		return render 'apiv1/organizations/members'     
	end  
	
	get :teams, :map => '/organizations/:org/teams' do  
		@teams = @org.teams
		return render 'apiv1/organizations/teams'
	end     
	
	get :team, :map => '/organizations/:org/teams/:team_name' do
		return render 'apiv1/organizations/team'
	end 
	
	put :updateteam, :map => '/organizations/:org/teams/:team_name' do
		if @team.update_attributes(params[:team])     
			return status 200 
		else 
			status 400     
			@errors = @team.errors
			render 'apiv1/errors/400'      
		end
	end  
	
	delete :deleteteam, :map => '/organizations/:org/teams/:team_name/' do
		if @team.delete  
			return status 200   
		else 
			status 400     
			@errors = @team.errors
			render 'apiv1/errors/400'      
		end
	end  
	
	get :team_members, :map => '/organizations/:org/teams/:team_name/members' do        
		@users = @team.members
		return render 'apiv1/organizations/users'            
	end   
	
	post :add_team_member, :map => '/organizations/:org/teams/:team_name/members/:username' do
		@team.add_member(@user)
		if @team.errors.length == 0 
			return render 'apiv1/organizations/user'            
		else 
			status 400     
			@errors = @team.errors
			render 'apiv1/errors/400'      
		end
	end    
	
	delete :delete_team_member, :map => '/organizations/:org/teams/:team_name/members/:username' do        
		@team.remove_member(@user)  
		if @team.errors.length == 0 
			return status 200 
		else 
			status 400     
			@errors = @team.errors
			render 'apiv1/errors/400'      
		end 
	end   
	
	get :team_repos, :map => '/organizations/:org/teams/:team_name/repositories' do    
		@repos = @team.repos({:private => false})
		return render 'apiv1/organizations/repos'
	end 
	
	post :add_team_repo, :map => '/organizations/:org/teams/:team_name/repositories/:user/:repo' do          
		@team.add_repo(@repo)
		if @team.errors.length == 0   
			return status 200 
		else 
			status 400     
			@errors = @team.errors
			render 'apiv1/errors/400'      
		end   
	end    
	
	delete :delete_team_repo, :map => '/organizations/:org/teams/:team_name/repositories/:user/:repo' do          
		@team.remove_repo(@repo)
		if @team.errors.length == 0   
			return status 200 
		else 
			status 400     
			@errors = @team.errors
			render 'apiv1/errors/400'      
		end   
	end
end