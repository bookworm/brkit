class Head   
  include MongoMapper::EmbeddedDocument   
  
  # Keys
  key :label, String
  key :ref,   String
  key :sha,   String     
  
end