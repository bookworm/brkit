# TODOS:
#   - Add blob retrieval.
#   - Add all blobs get.
#   - raw blob get, i.e data.contents.
Projects.controllers :apv1_object, :provides => [:json] do        
	
	get :tree, :map => '/tree/show/:user/:repo/:tree_sha' do
		@tree = @repo.repo.get_tree(params[:tree_sha])
	  if @tree
			return @tree.to_json
		else 
			status 404    
			render 'apiv1/errors/404'
		end
	end    
	
	# get :blob, '/blob/show/:user/:repo/:tree_sha/:path' do 
	# end
end