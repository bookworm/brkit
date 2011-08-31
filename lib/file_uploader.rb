class FileUploader < CarrierWave::Uploader::Base            

  ##
  # Storage type
  #   
  storage :file
   
	   
  # configure do |config|         
  # c config.s3_cnamed = true
  # c config.s3_access_key_id     = ENV['S3_ACCESS_KEY']
  # c config.s3_secret_access_key = ENV['S3_SECRET_ACCESS_KEY']
  # c config.s3_bucket =  ENV['S3_BUCKET'] 
  # cnd
  
  ## Manually set root
  def root; File.join(Padrino.root,"public/"); end

  ##
  # Directory where uploaded files will be stored (default is /public/uploads)
  # 
  def store_dir
    'uploads'
  end

  ##
  # Directory where uploaded temp files will be stored (default is [root]/tmp)
  # 
  def cache_dir
    Padrino.root("tmp")
  end

end