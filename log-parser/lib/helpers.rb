# frozen_string_literal: true

module Helpers
  def self.install_server(game_server)
    container_name = Lxc.create(game_server.name)
    Steamcmd.install_server(container_name, game_server)
    Systemd.install_server(container_name, game_server)
  end
end
