class Milestone
	include MongoMapper::Document      
	
	# Keys
	key :name,     String
	key :due_date, Time      
	
	# We will cache the closed and open issue count.
	# Why a completeness key? 
	# We may add more stuff later that factors into completeness, so best to store a calculated value. 
	# Pivot capability vbaby.
	key :closed,    Boolean
	key :open,      Boolean
	key :progresss, Integer    
	
	# Callbacks
	before_save :gen_progress
	before_update :gen_progress    

	## 
	# Effective. These effect associations with other mongodb docs.
	#
	
	def add_issue(details)   
	  Issue.new({:milestone_id => self.id}.merge(details))
  end
	
	## 
	# Associative Methods. These return other mongodb docs.
	# 
	
	def issues()  
		issues = Issue.all(:milestones => self.id)
	end
	
	def issue_count()        
	  Issue.count(:milestones => self.id) 
  end        
  
  def issue_count()        
	  Issue.count(:milestones => self.id) 
  end
  
  def closed_issue_count()        
	  Issue.count(:milestones => self.id, :state => 'closed')
  end
	     
	## 
	# Callbacks
	#
	
	def gen_progress()   
	  self[:progress] = closed_issue_count.fdiv(issue_count) * 100 
	end
end