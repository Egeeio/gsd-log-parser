# frozen_string_literal: true

module Systemd
  def self.install_server(container_name, game_server); end

  def create_unit_file(install_path)
    file_path = "/tmp/#{@game.name}.service"
    out_file = File.new(file_path, "w")
    out_file.puts(unit_file_contents(cli_path, install_path)) # TODO: Pass in map with config
    out_file.close()
    system("sudo -p 'sudo password: ' mv -f #{"/tmp/#{@game.name}.service"} /etc/systemd/system/#{@game.name}.service")
  end
end
