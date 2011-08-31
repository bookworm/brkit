class Team
	include MongoMapper::Document     
  
	# Keys
	key :title,         String
	key :name,          String
	key :user_ids,      Array  
	key :project_ids,   Array 
	key :permission_id, ObjectId  
	
	# Associations
	has_many :members, :class => 'Account', :in => :user_ids   
	has_one :permission, :foreign_key => :permission_id
	    
	##
	# Getter and Setter Methods 
	#
	 
	# Getters
	def permission_name()
	  self.permission.name
  end
	         
	## 
	# Associative Methods. These return other mongodb docs.
	#
	
	def projects(options={})
		Project.all({:teams => { '$in' => self[:project_ids] } }.merge(options))
	end    
	alias :repos :projects
	
	## 
	# Effective. These effect associations with other mongodb docs.
	#
	
	def add_member(user=nil) 
	  user = Account.current_account if !user 
		if !self[:user_ids].include?(user.id)
			self[:user_ids] << user.id
			self.save   
		else    
			errors.add(:user_already_member, 'User Already Member Of Tema')
		end
	end  
	
	def remove_member(user=nil)
	  user = Account.current_account if !user
		self[:user_ids].delete(user.id)
		self.save
	end  
	
	def add_project(project)    
	 	if !self[:project_ids].include?(project.id)
			self[:project_ids] << project.id
			self.save   
		else    
			errors.add(:project_already_member, 'Project Already Added To Team')
		end
	end 
	alias :add_repo :add_project      
	
	def remove_project(project)
		self[:project_ids].delete(project.id)
		self.save
	end
	alias :remove_repo :remove_project      
end