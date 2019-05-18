# frozen_string_literal: true

require "./lib/log_parser"

# Assorted helper methods
module DiscordHelpers
  def self.debug_notification(server, message)
    puts message
    debug_channel(server).send_message(message)
  end

  def self.discord_channel(server, channel_name)
    server.channels.select { |x| x.name == channel_name }.first
  end

  def self.check_last_message(channel, msg)
    channel.history(1).first.content.include?(msg)
  end

  def self.delete_last_message(channel)
    channel.history(1).first.delete
  end

  def self.debug_channel(server)
    discord_channel(server, "debug")
  end

  def self.misc_games_channel(server)
    discord_channel(server, "misc-games")
  end

  def self.game_announce(server, games)
    log_parser = LogParser.new(games)
    log_parser.parse()
    log_parser.players.each do |game, players|
      next unless players.empty? == false

      players_string = players.join(",")
      channel = discord_channel(server, game)
      channel = misc_games_channel(server) if channel.nil?
      msg = "**#{players_string}** has joined the #{game_normalizer(game)} server"
      channel.send_message(msg) unless check_last_message(channel, msg)
    end
    log_parser.reset()
  end

  def self.game_normalizer(game)
    if game == "sdtd"
      "7 Days to Die"
    else
      game
    end
  end
end
