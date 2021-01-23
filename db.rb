require 'sequel'

DB = if ENV['DATABASE_HOST']
  Sequel.connect "postgres://#{ENV['DATABASE_USER']}:#{ENV['DATABASE_PASS']}@#{ENV['DATABASE_HOST']}/#{ENV['DATABASE_NAME']}"
elsif ENV['DATABASE_URL']
  Sequel.connect ENV['DATABASE_URL']
else
  Sequel.connect 'sqlite://./local.db'
end
