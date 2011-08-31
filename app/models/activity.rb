class Activity
	include MongoMapper::Document
	plugin MongoMapper::Plugins::Timestamps         
	
	# Keys
	key :author_id,  ObjectId   
	key :project_id, ObjectId     
  key :title,      String
	key :message,    String
	key :data_s,     String   
	key :data_h,     Hash        
	key :type,       String
	
	# Key Settings
	timestamps!        
end