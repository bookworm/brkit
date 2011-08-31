MongoMapper.connection = Mongo::Connection.new('localhost', nil, :logger => logger)

case Padrino.env
  when :development then MongoMapper.database = 'brkit_development'
  when :production  then MongoMapper.database = 'brkit_production'
  when :test        then MongoMapper.database = 'brkit_test'
end
