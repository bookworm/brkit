class Comment 
	include MongoMapper::Document
	include MongoMapperExt::ParseMarkDown     
	plugin MongoMapper::Plugins::Timestamps  
	 
	# Keys
	key :author_id, ObjectId 
	key :desc,      String
	key :desc_raw,  String
	key :issue_id,  ObjectId
	
	# Key Settings
	timestamps!    
	
	# Callbacks
	before_save :parse_markdown
end