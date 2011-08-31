class Archive
	include MongoMapper::Document
   
  # Keys   
  key :filename, String
	key :repo_id,  ObjectId
  
	# Key Settings
	mount_uploader :file, FileUploader       
end