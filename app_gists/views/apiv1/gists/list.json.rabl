object @gists

child @gists do  

  child @comments do
    child @comment do  
      attributes :created_at
      attribute :desc_raw => :description       
      glue :user do
        attribute :name => :user
      end
    end   
  end 
  
  attributes :created_at
  attribute :desc_raw => :description
  
end