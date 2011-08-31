class Issue
	include MongoMapper::Document     
	include MongoMapperExt::ParseMarkDown   
	plugin MongoMapper::Plugins::Timestamps  
	
	# Keys   
	key :title,           String
	key :desc_raw,        String 
	key :desc,            String
	key :status,          String, :default => 'open'   
	key :assigned,        Array 
	key :participants,    Array     
	key :labels,          Array
	key :milestones,      Array 
	key :num_id,          Integer  
	key :project_id,      ObjectId
	key :comment_ids,     Array
	                           
	# Key Settings  
	timestamps! 
 
	# Callbacks
	before_save :parse_markdown, :gen_num_id
	before_update :parse_markdowm  
	   
	## 
	# Collection Methods
	# 
	
	def self.labels(options={})
		Issue.collection.distinct('labels', options)
	end
	
	##
	# Getter and Setter Methods 
	#
	   
	# Setters
	def close()
		self[:status] = 'closed'
		self.save
	end  
	
	def open()
		self[:status] = 'open'
		self.save
	end

  # Getters
	def comment_count()    
    Comment.count(:issue_id => self.id)
  end  
        
	## 
	# Effective. These effect associations with other mongodb docs.
	#
	
  def add_comment(details, user=nil)
		user = Account.current_account if !user
		Comment.new({:author_id => user.id, :issue_id => self.id}.merge(details))
	end
  
  ##
  # Callbacks
  #
  
  def gen_num_id()
		count = Issue.count(:project_id => self.id) + 1
	end 

end