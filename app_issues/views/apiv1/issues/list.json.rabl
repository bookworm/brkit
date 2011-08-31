object @issues

child @issues do
  attributes :title,  
  attribute :desc_raw => :description
  attributes :comment_count, :labels, :created_at, :updated_at, :state  
end