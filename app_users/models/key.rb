# Some of this ported from gitorous
class Key
  include MongoMapper::Document 
  
  SSH_KEY_FORMAT = /^ssh\-[a-z0-9]{3,4} [a-z0-9\+=\/]+ Key:(\d+)?-User:(\d+)?$/ims.freeze

  # Keys         
	key :title,      String  
	key :name,       String 
  key :raw,        String 
  key :account_id, ObjectId 
  key :project_id, ObjectId          
  
  def owner()
    Account.first(:id => self[:account_id])
  end   
  
  def self.add_to_authorized_keys(keydata)
    key_file = SSHKeyFile.new
    key_file.add_key(keydata)
  end
  
  def self.delete_from_authorized_keys(keydata)
    key_file = SSHKeyFile.new
    key_file.delete_key(keydata)
  end
	
	## 
	# Collection methods
	# 
	
	def to_key
    %Q{### START KEY #{self.id || "nil"} ###\n} +
    %Q{command="brkit #{self.owner.username}",no-port-forwarding,} +
    %Q{no-X11-forwarding,no-agent-forwarding,no-pty #{to_keyfile_format}} +
    %Q{\n### END KEY #{self.id || "nil"} ###\n}
  end  
  
  # The internal format we use to represent the pubkey for the sshd daemon
  def to_keyfile_format
    %Q{#{self.algorithm} #{self.encoded_key} Key:#{self.id}-User:#{self.account_id}}
  end  
  
  def components
    self[:raw].to_s.strip.split(" ", 3)
  end
  
  def algorithm
    components.first
  end
  
  def encoded_key
    components.second
  end   
  
  def comment
    components.last
  end  
  
  def valid_key_using_ssh_keygen?
    temp_key = Tempfile.new("ssh_key_#{Time.now.to_i}")
    temp_key.write(self.raw)
    temp_key.close
    system("ssh-keygen -l -f #{temp_key.path}")
    temp_key.delete
    return $?.success?
  end
end