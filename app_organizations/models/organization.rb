class Organization
 	include MongoMapper::Document     
  
	# Keys         
	key :name,     String
	key :desc,     String
	key :team_ids, Array
	key :projects, Array
	key :user_ids, Array 
	key :company,  String  
	key :blog,     String
	 
	# Associations
	has_many :members, :class => 'Account', :in => :user_ids 
	has_many :teams, :in => :team_ids   
	 
	## 
	# Associative Methods. These return other mongodb docs.
	#
	
	def repos(options)
		Project.all({:organization_id => self.id}.merge(options))
	end   
	alias :projects :repos 
	
	def public_repo_count()      
	  Project.count({:organization_id => self.id, :private => false }) 
  end
  
  def public_gist_count()  
   Gist.count({:organization_id => self.id, :private => false}) 
  end    
  
  def private_gist_count()
    Gist.count({:organization_id => self.id, :private => true})   
  end     
  
  def private_repo_count()        
    Project.count({:organization_id => self.id, :private => true })
  end
end