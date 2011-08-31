require 'redcarpet'  
# TODO: Need something like github-markup to automagically determine readme file types.
class Project
  include MongoMapper::Document   
	include MongoMapperExt::Slugizer        
	include MongoMapperExt::ParseMarkDown   
	include MongoMapperExt::Filter
  plugin MongoMapper::Plugins::Timestamps     
  
  # Keys          
	key :title,       String   
	key :name,        String
	key :desc_raw,    String 
	key :desc,        String
	key :readme,      String    
	key :forked_from, ObjectId   
	key :forked,      Boolean, :default => false
	key :private,     Boolean, :default => false 
	key :forks,       Array   
	key :repo_id,     ObjectId   
	key :homepage,    String  
	key :wiki_id,     ObjectId
		
	# Contributors With Access
	key :contributors,    Array	
	key :collaborators,   Array
	key :teams,           Array  
	key :author_id,       ObjectId
	key :organization_id, ObjectId 
	
	# Key Settings
	timestamps!    
	filterable_keys :title, :desc_raw     
	
	def initialize(args)
    super(args)
    user = Account.current_account
    self.author_id = user.id if user && !self.author_id
    self.name = self.title.downcase.parameterize.to_s if self.name.blank?
  end 
           
	# Associations
	has_one :repo, :class_name => 'Repo', :foreign_key => :project_id      
	belongs_to :author, :class_name => 'Account', :foreign_key => :author_id
	belongs_to :organization, :class_name => 'Organization', :foreign_key => :organization_id

	# Callbacks
	before_save :parse_markdown, :create_repo
	before_update :parse_markdowm, :parse_readme  
	after_destroy :delete_repo, :delete_from_watch_lists    
	
	# Validations
	validates_presence_of :title
	validates_presence_of :desc_raw 
	validates_presence_of :author_id  
	
	##
	# Getter and Setter Methods 
	#  
	
	# Getters
	
	def url()   
	  #'http://' << ENV['DOMAIN'] << 
	  '/' << self.author.username.to_s << '/' << self.name.to_s
  end     
  
  def has_wiki()
    return true if self[:wiki_id]    
    false
  end       
  
  def has_issues()
    return true if Issue.count({:project_id => self.id}) > 0
    false
  end
  
  def pushed_at
    self.repo.pushed_at
  end     
  
  def owner()
    self.author.name
  end
	    
	# Setters 
	
	def make_private()
		self[:private] = true
	  self.save
	end   
	
	def make_public()
		self[:private] = false
		self.save
	end   
	
	def owner=(user=nil)        
	  user = Account.current_account if !user 
	  if user.is_a?(Account)    
  	  self[:author_id] = user.id    
    else
      self[:author_id] = user
    end
  end
  alias :author= :owner=     
	
	## 
	# Associative Methods. These return other mongodb docs.
	#
	
	def collaborators()      
		Account.all(:id => { "$in" => self[:collaborators]})
	end  
	
	def contributors()      
		Account.all(:id => { "$in" => self[:contributors]})
	end    
	
	def watchers()      
		Account.all(:watching => self.id)
	end  
	
	def pulls(state='open', options={})
		Pull.all(:state => 'open', :to_project_id => self.id)
	end    
	 
	# Only get_keys because we cant have a method called keys()
	def get_keys(user=nil)  
		user = Account.current_account if !user
		Key.all(:account_id => user.id, :project_id => self.id)
	end  
	
	def watchers_count()
	  self[:watchers].length
  end
  
  def forks_count()
    Project.count({:forked_from => self.id })
  end
  
  def open_issues_count()  
    Issue.count({:project_id => self.id, :status => 'open'})
  end      

	## 
	# Effective. These affect associations with other mongodb docs.
	#      
	
	def add_key(options={},user=nil)   
		user = Account.current_account if !user
		Key.new({:account_id => user.id, :project_id => self.id}.merge(options))
	end
	
	def add_collaborator(user_id) 
		collaborator = Contributor.first(:user_id => user_id, :project_id => self.id)    
		return collaborator if self[:collaborators].include?(user_id) 
		
		permission = Permission.first(:name => 'collaborator') 
		
		if !contrib
			collaborator = Contributor.new(:user_id => user_id, :project_id => self.id) 
		end    
		
		collaborator.add_permission(permission)
		
		if collaborator.save
			self[:collaborators] << user_id
			self.save  
		else    
			errors.add(:collaborator, collaborator.errors.full_messages.to_s)
			return false    
		end
	end  
	
	def remove_collaborator(user_id)    
		permission   = Permission.first(:name => 'collaborator') 
		collaborator = Contributor.first(:user_id => user_id, :project_id => self.id)
		collaborator.remove_permission(permission)
		self[:collaborators].delete!(user_id)   
		self.save
	end    
	
	def add_pull(details)    
		from_project = Project.first(:author_id => Account.current_account.id, :name => self.name)
		 
		repo_details = {}
		repo_details[:from_project_id] = from_project.id   
 		repo_details[:to_project_id]   = self.id  

		pull = Pull.new(details.merge(repo_detials))    
		to_project = nil   
		      
		return pull
	end 
	
	def add_issue(details, user=nil)      
		user = Account.current_account if !user
		Issue.new({:author_id => user.id, :project_id => self.id}.merge(details))	
	end
	
	def fork(user=nil)
	  user = Account.current_account if !user   
	  
	  # Create the actual Git Repo.
	  path = '' 
	  path << Padrino.root << '/repos/' << user.username << '/' << self.name << '.git'
	  gitrepo = project.repo.repo.fork_bare(path, {:bare => false, :shared => true} )     
	  
	  branches = gitrepo.branches.map { |branch| branch.name }       
	  tags = gitrepo.tags.map { |tag| tag.name }
	  
	  repo = Repo.new(:author_id => user.id, :name => self.name, :path => path, :branches => branches, :tags => tags) 
	  if repo.save   
	  	forked = Project.new(:title => self.title, :name => self.name, 
	  						:desc_raw => self.desc_raw, :readme => self.readme, :forked_from => self.id, 
	  						:author_id =>  user.id, :repo_id => repo.id)    
	  	return forked if forked.save
	  	self.errors = forked.errors
	  else 
	  	self.errors = repo.errors
	  end 
	end   

	##
	# Callbacks
	#   
	 
	# Save
	def generate_slug
	  max_length = self.class.slug_options[:max_length]
	  min_length = self.class.slug_options[:min_length] || 0
    	
	  slug = self.account.username.parameterize.to_s << self.repo.name.parameterize.to_s
	  slug = slug[0, max_length] if max_length

	  if slug.size < min_length
	    slug = nil
	  end  

		self.slug = slug
	end  

	def create_repo()
		if self[:repo_id].blank?
			repo = Repo.new(:author_id => self[:author_id], :name => self[:name], :project_id => self.id)
			if repo.save  
				self[:repo_id] = repo.id
			else
				errors.add(:repo_save_failed, 'Failed To Create Repo.') 
				errors.add(:repo_error_message, repo.errors.full_messages.to_s)
			end 
		end
	end  
	
	# Delete    
	def delete_repo()
		self.repo.destroy
	end  
	
	def delete_from_watch_lists() 
	  users = Account.all(:watching => self.id)     
	  users.each do |user|
	    user.unwatch(self)
    end
  end
	
	# Updates
	def parse_readme  
		return if !new_commit_to?('README.md') 
		markdown = Redcarpet.new(get_file('README.md'))
		self[:readme] = markdown.to_html
	end 
end 