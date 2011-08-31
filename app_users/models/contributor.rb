class Contributor
	include MongoMapper::Document
	
	# Keys
	key :user_id,        ObjectId
	key :project_id,     ObjectId
	key :permission_ids, Array
	key :permissions,    Array   
	
	# Assocations
	belongs_to :project, :foreign_key => :project_id   
	
	## 
	# Effective. These affect associations with other mongodb docs.
	#
	
	# Adds
	
	def add_permission(permission)  
		self[:permission_ids] << permission.id 
		self[:permissions]    << permission.name
		self.save
	end
	       
	# Removes
	
	def remove_permission(permission)     
		self[:permission_ids].delete!(permission.id)   
		self[:permissions].delete!(permission.name)
		self.save
	end
end