require 'digest/sha1'      
require 'digest/md5'
class Account
  include MongoMapper::Document 
	plugin MongoMapper::Plugins::Timestamps

  # Keys
  key :first_name,       String  
  key :last_name,        String
  key :username,         String
  key :email,            String
  key :crypted_password, String
  key :salt,             String
  key :roles,            Array     
	key :watching,         Array
	key :following,        Array 
	key :organizations,    Array   
	key :gists,            Array   
	key :gravatar_id,      String 
	key :company,          String
	key :location,         String  
	key :blog,             String 
	key :show_email,       Boolean, :default => true         
	key :password,         String   
	                              
	# Key Settings
	timestamps!

  # Validations
  validates_presence_of     :email                      
  validates_presence_of     :password,                   :if => :password_required
  validates_length_of       :password, :within => 4..40, :if => :password_required
  validates_confirmation_of :password,                   :if => :password_required       
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i        
	
  # Callbacks
  before_save :gen_pass, :gen_gravatar    
  before_update :gen_pass 
  
  ## 
  # Collection Methods
  
  def self.current_account() 
    if defined?(@@current_account) 
      return @@current_account 
    end
    return nil
  end  
  
  def activity_on_user()
    Activity.where('$or' => [{ :project_id => { "$in" => repo_ids } }] ).all
  end         
  
  def repo_ids()
    repo_ids = Project.fields([:_id]).all(:author_id => self.id) 
    repo_ids = repo_ids.map { |repo| repo.id }    
    repo_ids
  end

  ## 
	# Getters & Setters
	#       
	
  def name()  
    return "#{self[:first_name]}, #{self[:last_name]}"
  end    
  
  def email()
    return self[:email] if self[:show_email] == true  
    return 'hidden'
  end

  ## 
	# Associative Methods. These return other mongodb docs.
	#
	
	def following()  
		Account.all(:id => { "$in" => self[:following]})
	end       
	
	def followers()   
		Account.all(:following => self[:_id])
	end     
	
	def watched()
		Project.all(:id => { "$in" => self[:watching] })
	end   
	
	def get_keys()
		Key.all(:account_id => self.id)
	end  
	
	def pushable()	     
		pushable = []
		contribs = Contributor.all(:user_id => self.id, :permissions => 'push')   
		contribs.each do |push|
			pushable << push.project
		end
		contribs = nil
		pushable
	end  
	
	def organization_repos()     
		Project.all(:organization_id => { "$in" => self[:organizations] })
	end
	
	def organizations()  
	  Organization.all({:user_ids => self.id})
  end  
	
	def gists(options={}) 
		Gist.all({:author_id => self.id }.merge(options))	
	end    
	
	def activity(options={})
	  Activity.all({:author_id => self.id}.merge(options))
  end 
	   
	# Returns the acvity messages from user or projects this user is following or watching repsectively.
	def activity_watching_following()
	  Activity.where('$or' => [{ :project_id => { "$in" => self[:watching] } }, { :project_id => { "$in" => repo_ids } }, {:author_id => { "$in" => self[:following] }}] ).all
  end   
  
  def public_repos()
    Project.all({:author_id => self.id, :private => false })
  end
  
  def repos()  
    Project.all(:author_id => self.id)  
  end
	
	def public_repo_count()      
	  Project.count({:author_id => self.id, :private => false }) 
  end
  
  def public_gist_count()  
   Gist.count({:author_id => self.id, :private => false}) 
  end    
  
  def private_gist_count()
    Gist.count({:author_id => self.id, :private => true})   
  end     
  
  def private_repo_count()        
    Project.count({:author_id => self.id, :private => true })
  end
  
  def following_count()
    self.following.length
  end
  
  def followers_count() 
    Account.count({:following => self.id })
  end    
  
  def message_count()    
    Message.count({:to => self.id })   
  end 
  
	## 
	# Effective. These affect associations with othe rmongodb docs.
	#    
	
	def follow(user)
	  self[:following].push(user.id)
		self.save
  end   
  
  def unfollow(user)
    self[:following].delete(user.id)
		self.save
  end
	
	def unwatch(project)
		self[:watching].delete(project.id)
		self.save
	end 
	
	def watch(project)   
		self[:watching].push(project.id)
		self.save
	end  
	
	##
	# Authorization & Authentication
	# 
	
  # This method is for authentication purposes
  def self.authenticate(email, password=nil)   
    puts password
    enc_password = Digest::SHA1.hexdigest([email, password, ENV['PASS_SALT_SECRET']].join('::'))  
    account = self.first(:email => email) if email.present?
    account && account.crypted_password == Digest::SHA1.hexdigest([enc_password, account.salt].join('::')) ? account : nil  
  end    

  def roles=(t)
    if t.kind_of?(String)
      t = t.downcase.split(",").join(" ").split(" ").uniq
    end
    self[:roles] = t
  end    

  def roles_to_s()   
    self[:roles].join(",")  
  end    

  def has_role?(role)     
    return self.roles.include?(role)
  end 
  
  ##
  # Callbacks
  #
  private
    def gen_gravatar()
      email_address = self[:email].downcase
      self[:gravatar_id] = email_address.to_md5
    end  
      
	  def gen_pass
	    return if self.password.blank?               
	    puts 'hi'
	    self.salt             = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
	    password_pre_crypt    = Digest::SHA1.hexdigest([self.email, self.password, ENV['PASS_SALT_SECRET']].join('::'))
	    self.crypted_password = Digest::SHA1.hexdigest([password_pre_crypt, self.salt].join('::'))   
	    self.password = nil
	  end    
	  
	  def password_required
      crypted_password.blank? || !self.password.blank?
    end 
end