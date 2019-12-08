# frozen_string_literal: true

require 'mongo'

game = 'sshd'
collection = "#{game}-server".to_sym
time_ago = '300'

client = Mongo::Client.new('mongodb://egee.io:/test')
collection = client[collection]
doc = { name: game, user: 'mrjs' }

loop do
  puts `journalctl --since '#{time_ago}ms ago' --no-pager -u #{game}`
  collection.insert_one(doc)
  sleep 3
end
