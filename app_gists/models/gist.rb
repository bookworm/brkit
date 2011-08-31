# Like allot the models in this app the main thing this does is just allow us to cache the processed coe.   
require 'github/markup'
class Gist
  include MongoMapper::Document       
  
	# Keys                  
	key :author_id,   ObjectId
  key :repo_id,     ObjectId
	key :repo_name,   String
	key :branch,      String
	key :tag,         String   
	key :filename,    String
	key :mimetype,    String
	key :raw,         String  
	key :processed,   String         
	key :forked_from, ObjectId 
	key :starred,     Boolean
	key :private,     Boolean, :default => false     
	
	# Defaults
	def initialize(args)
    super(args)
		self.branch = 'master' if !self.tag
  end
	   
	# Validations
	validates_presence_of :mime 
	validates_presence_of :raw
	    
	# Associations
	belongs_to :author, :class_name => 'Account', :foreign_key => "author_id"              
	
	# Callbacks
	before_save :process      
 
	##
	# Getter and Setter Methods 
	#  
	
	# Setters  
	
	def star() 
		self[:starred] = true
	end
	
	def unstar() 
		self[:starred] = false
	end    
	  
	## 
	# Associative Methods. These return other mongodb docs.
	#
	
	def repo()   
		repo = Repo.first(:id => self[:repo_id])
	end
	
	## 
	# Effective. These effect associations with other mongodb docs.
	#
	
	def fork(user=nil)
		user = Account.current_account if !user
		path = '' 
		path << Padrino.root << '/repos/' << user.username << '/gists/' << self.name << '.git'
		gitrepo = gist.repo.repo.fork_bare(path, {:bare => false, :shared => true} )     
		
		repo = Repo.new(:author_id => user.id, :name => self.name, :path => path) 
		if repo.save   
			forked = Gist.new(:title => self.title, :name => self.name, 
								:desc_raw => project.desc_raw, :readme => project.readme, :forked_from => self.id, 
								:author_id => user.id, :repo_id => repo.id)    
			return forked if forked.save
			self.errors = forked.errors
		else 
			self.errors = repo.errors
		end
	end  
	
	##
	# Callbacks
	#

	def process
		if Albino.supported_mime?(self[:mimetype]) 
			self[:processed] = Albino.colorize(self[:raw], Albino.mime_to_lang(self[:mimetype]).to_sym)
		elsif Github::markup.supported_ext?(/(.*\.)(.*$)/.match(self[:filename]))   
			self[:processed] = GitHub::Markup.render(self[:filename], self[:raw])
		end
	end  
	
	# def self.build_codeobj_from_file(repo, filename, branch_or_tag='master')  
	# 	options          = {:author_id => repo.author.id, :repo_id => repo.id, :repo_name => repo.name}  
	# 	options[:tag]    = branch_or_tag if repo.tags.include?(branch_or_tag)  
	# 	options[:branch] = branch_or_tag  
	# 	options[:mimetype] = repo.get_file_mime(filename, branch_or_tag)      
	# 	options[:raw] = repo.get_file(filename, branch_or_tag)
	# 	return Code.new(options)
	# end
end