class Pull  
	include MongoMapper::Document    
	
	# Keys
	key :num_id,          Integer 
	key :state,           String, :default => 'open'   
	key :from_project_id, String
	key :to_project_id,   String
	key :issue_id,        String                              
	
	# Callbacks
	before_save :parse_markdown  
	
	# Associations
	has_one :base, :class => 'Head'
	has_one :head    
	has_one :issue, :foreign_key => :issue_id
end