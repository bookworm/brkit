# TODOS:
#   - Specific file.
#   - Specific commit
Projects.controllers :apv1_commits, :provides => [:json], :map => '/api/v1' do               
	
	get :branch_commits, :map => '/commits/list/:user/:repo/:branch' do
		@commits = @repo.repo.repo.commits(params[:branch], params[:limit], params[:skip])
		return @commits.to_json  
	end       
	
  get :file_commits, :map => '/commits/list/:user/:repo/:branch/:path' do
  end
end