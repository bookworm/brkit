# TODOS:
#   - Languages statistics.
class Repo
  include MongoMapper::Document    
  
	# Attributes. 
	# These are NEVER saved with the model.
  @repo        = nil  
	@new_commits = nil   
	@last_commit = nil

  # Keys  
	key :author_id,  ObjectId
	key :name,       String  
	key :path,       String  
	key :branches,   Array
	key :tags,       Array 
	key :languages,  Array  
	key :pushed_at,  Time    
	key :type,       String, :default => 'project'    
	key :project_id, ObjectId 
	key :gist_id,    ObjectId
	
	# Key Settings
	timestamps!
	
	# Callbacks
	before_save :gen_path, :init_repo_if_doesnt_exist
  
	# Associations
 	belongs_to :author, :class_name => 'Account', :foreign_key => "author_id" 
 	belongs_to :project, :foreign_key => "project_id"   
 	belongs_to :gist, :foreign_key => "gist_id"         
	has_many   :commits 
	has_many   :archives 
  after_destroy :delete_repo, :delete_commits, :delete_archives 
	
  ## 
  # Instance methods.
  #

  # Gets The Most Recent Commit
  def last_commit() 
	  return @last_commit if @last_commit.is_a?(Commit)
		@last_commit = Commit.first(:repo_id => self[:_id])
	end     
	 
	# Returns a Grit::Git repo object.
	def repo()  
		return @repo if @repo != nil
		@repo = Grit::Repo.new(self[:path])
	end    
	  
	# Has there been any new commits?     
	# We use this to detemrine if we should pull any changes from the repo. 
	def new_commits?()
		return @new_commits if @new_commits.is_a?(Boolean)   
		head = repo().commits.first
		if head.committed_date > last_commit.committed_date 
			@new_commits = true
		else
			@new_commits = false 
		end
		return @new_commits
	end    
	 
	# Checks if a file has changed.
	def new_commit_to?(filename, branch_or_tag='master')      
		log = repo.log(branch_or_tag, filename)
		if log.first.committed_date > last_commit.committed_date      
			return true   
		else 
			return false
		end
	end  
	
	# Gets a file's data from the repo
	def get_file(filename, branch_or_tag='master')      
		log = repo.log(branch_or_tag, filename)   
		return log.first.tree.contents.first.data
	end   
	
	def get_file_mime(filename, branch_or_tag='master')     
		log = repo.log(branch_or_tag, filename)   
		return log.first.tree.contents.first.mime_type
	end                
	
	def get_tree(tree)
		repo.list_tree(tree)
	end
	
	## 
	# Callbacks
  #

  # Saves

  def gen_path()
		if self[:path].blank?
			self[:path] = Padrino.root << '/repos/' << self.author.username << '/'
			self[:path] << 'gists/' << self.name if self[:type] == 'gist'
		  self[:path] << self.name if self[:type] == 'project'
			self[:path] << '.git'
		end   
	end   
	
	def init_repo_if_doesnt_exist()
		if !File.exist?(path)
			Grit::Repo.init_bare(path)
		end
	end  
	
	# Delete
	
	def delete_repo() 
		FileUtils.rm_rf(self[:path])
	end 
	
	def delete_commits()
		Commit.delete_all(:repo_id => self.id)
	end 
	
	def delete_archives() 
		Archive.destroy_all(:repo_id => self.id)
	end
end