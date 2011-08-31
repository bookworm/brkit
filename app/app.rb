class Brkit < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Rendering   
  register Padrino::Admin::AccessControl
  register CompassInitializer
  register AssetHatInitializer

  enable :sessions
end