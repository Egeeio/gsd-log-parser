# frozen_string_literal: true

require 'yaml'
require './lib/helpers/discord.rb'

# The module that contains and handles all events associated with Discord
module DiscordEvents
  extend Discordrb::Commands::CommandContainer
  extend Discordrb::EventContainer
  extend DiscordHelpers

  # Server event handler
  member_join do |event|
    DiscordHelpers.debug_channel(event.server)
      .send_message("#{event.user.username} just joined the server.")
  end

  member_leave do |event|
    DiscordHelpers.debug_channel(event.server)
      .send_message("#{event.user.username} just left the server.")
  end

  # General message event handler
  command :help do
    <<~TEXT
      Billy Mays programmed me with the following commands:
      ~assign_role
      ~fortune
      ~chucknorris
      ~ghostbusters
      ~moo
      ~translate
      ~catpic
      ~catgif
    TEXT
  end

  command :assign_role do |event, *role|
    role = role.join(' ')&.downcase
    next 'Role name required' if role.empty?

    config = YAML.load_file('./config.yml')
    config['protected_roles'].each do |r|
      role = 'invalid' if r.downcase.include?(role)
    end
    event.server.roles.each do |r|
      next unless r.name.downcase.include?(role)

      begin
        event.author.add_role(r)
        role = 'valid'
      rescue
        role = 'invalid'
      end
    end
    if role == 'invalid'
      'Invalid role. Try something else.'
    elsif role == 'valid'
      'Done!'
    else
      'No.'
    end
  end

  # Fun message event handler
  command :fortune do
    "```\n#{`/usr/games/fortune -s | cowsay`}\n```"
  end

  command :ghostbusters do
    "```\n#{`/usr/games/cowsay -f ghostbusters Who you Gonna Call`}\n```"
  end

  command :moo do
    "```\n#{`apt-get moo`}\n```"
  end

  command :chucknorris do
    JSON.parse(RestClient.get('http://api.icndb.com/jokes/random?exclude=[explicit]')).dig('value', 'joke')
  end

  command :translate do |event|
    DiscordHelpers.delete_last_message(event.channel)
    test = event.message.content.slice(11..event.message.content.length)
    RestClient.post 'http://api.funtranslations.com/translate/jive.json', text: test do |response, _request, result|
      if result.code == '429'
        JSON.parse(result.body).dig('error', 'message')
      else
        JSON.parse(response.body).dig('contents', 'translated')
      end
    end
  end

  command :catpic do
    RestClient.get('http://thecatapi.com/api/images/get?format=src&type=jpg').request.url
  end

  command :catgif do
    RestClient.get('http://thecatapi.com/api/images/get?format=src&type=gif').request.url
  end
end