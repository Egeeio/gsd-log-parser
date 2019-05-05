# frozen_string_literal: true

require "./lib/lxc"

# Commands for interacting with Steamcmd
module Steamcmd
  def self.install_server(container, app_id, path, credentials = nil)
    install_steamcmd(container) if steamcmd_exists?(container) == false
    Lxc.exec_tty(container, "/opt/steamcmd.sh #{steamcmd_login(credentials)} +force_install_dir #{path} +app_update #{app_id} validate +quit")
  end

  def self.install_steamcmd(container)
    Lxc.exec_tty(container, "dpkg --add-architecture i386")
    Lxc.exec_tty(container, "apt-get update")
    Lxc.exec_tty(container, "apt-get install -y gcc-8-base gcc-8-base:i386 libc6:i386 libgcc1 libgcc1:i386 libstdc++6 libstdc++6:i386")
    Lxc.exec_tty(container, "cd /opt/ && curl -sqL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf -")
    puts "done"
  end

  def self.steamcmd_exists?(container)
    test = if Lxc.exec(container, "cat /opt/steamcmd.sh").include?("STEAMEXE=")
             puts "steamcmd appears to be installed"
             true
           else
             puts "steamcmd does not appear to be installed, installing..."
             false
           end
    test
  end

  def self.steamcmd_login(credentials)
    login = if credentials.nil?
              "+login anonymous"
            else
              "+login #{credentials.user} #{credentials.password}"
            end
    login
  end

  def self.accept_steam_license
    Lxc.exec_tty(container, "echo steam steam/question select 'I AGREE' | debconf-set-selections")
    Lxc.exec_tty(container, "echo steam steam/license note '' | debconf-set-selections")
  end
end
