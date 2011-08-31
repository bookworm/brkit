object @user

attributes :gravatar_id, :company, :name, :created_at, :location, :public_repo_count, :public_gist_count, :blog, :following_count, :followers_count, :email, :collaborators_count   

if @current_account != nil && @user.id == @current_account.id
  attributes :private_gist_count, :private_repo_count
end