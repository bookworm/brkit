object @pulls

child @pulls do 
  attributes :base, :head, :state, :created_at

  glue @issue do
    attributes :title,  
    attribute :desc_raw => :description
    attributes :comment_count, :labels
    attribute :updated_at => :issue_updated_at
  end   
end