##
# This file mounts each app in the Padrino project to a specified sub-uri.
# You can mount additional applications using any of these commands below:
#
#   Padrino.mount("blog").to('/blog')
#   Padrino.mount("blog", :app_class => "BlogApp").to('/blog')
#   Padrino.mount("blog", :app_file =>  "path/to/blog/app.rb").to('/blog')
#
# You can also map apps to a specified host:
#
#   Padrino.mount("Admin").host("admin.example.org")
#   Padrino.mount("WebSite").host(/.*\.?example.org/)
#   Padrino.mount("Foo").to("/foo").host("bar.example.org")
#
# Note 1: Mounted apps (by default) should be placed into the project root at '/app_name'.
# Note 2: If you use the host matching remember to respect the order of the rules.
#
# By default, this file mounts the primary app which was generated with this project.
# However, the mounted app can be modified as needed:
#
#   Padrino.mount("AppName", :app_file => "path/to/file", :app_class => "BlogApp").to('/')
#

##
# Setup global project settings for your apps. These settings are inherited by every subapp. You can
# override these settings in the subapps as needed.
#
Padrino.configure_apps do
  # enable :sessions
  set :session_secret, '61077b21e84d10b6caec0e1cc0d0a8880a79d549f36932186a82b1ac886631d9'
end

# Mounts the core application for this project 
Padrino.mount("Brkit", :app_file => "#{Padrino.root}/app/app.rb").to('/')  
Padrino.mount("Users", :app_file => "#{Padrino.root}/app_users/app.rb").to("/user")      
Padrino.mount("Projects",  :app_file => "#{Padrino.root}/app_projects/app.rb").to("/")
Padrino.mount("Organizations", :app_file => "#{Padrino.root}/app_organizations/app.rb").to("/")
Padrino.mount("Gists", :app_file => "#{Padrino.root}/app_gists/app.rb").to("/")
#Padrino.mount("Admin").to("/admin")
# Padrino.mount("Issues", :app_file => "#{Padrino.root}/app_issues/app.rb").to("/")