class Message
  include MongoMapper::Document 
	plugin MongoMapper::Plugins::Timestamps      
	
	# Keys
	key :to,      ObjectId
	key :from,    ObjectId   
	key :message, String
	
end