class Permission
	include MongoMapper::Document     
	
	# Keys
	key :granularity, String, :default => 'project'   
	key :permission,  String    
	key :permissions, Array    
end