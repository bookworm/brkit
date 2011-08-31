class Commit
  include MongoMapper::Document   

	# Keys
	key :id,             String    
	
	# For now this is just an array of IDs so we can retrieve using Grit directly from the repo.
	# In the future we might do something more complicated are store the associations between commits in the DB.
	# But thats probably not the awesomest idea because essentially the commit objects are only stored in the DB for caching.
	# We don't really nned to or want to be duplicating the entire commit tree,
	# In fact mongodb side we will probably decay/prune/delete commmit docs that are after a certain date.
	key :parents,        Array
	key :authored_date,  Time
	key :committed_date, Time
	key :committer_id,   ObjectId    
	key :author_id,      ObjectId  
	key :repo_id,        ObjectId 
	key :project_id,     ObjectId
	key :message,        String
	key :tree,           String
	
	# Associations.
	belongs_to :repo, :foreign_key => :repo_id
	belongs_to :project, :foreign_key => :repo_id     
	
	## 
	# Associative Methods. These return other mongodb docs.
	#
	
	def committer() 
		Account.first(:id => self[:committer_id])
	end     
	
	def author() 
		Account.first(:id => self[:author_id])
	end
end