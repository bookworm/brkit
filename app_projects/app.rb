class Projects < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers 
  register Padrino::Rendering   
  register Padrino::Admin::AccessControl
  register CompassInitializer

  enable :sessions

end