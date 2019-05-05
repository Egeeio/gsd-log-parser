# frozen_string_literal: true

$LOAD_PATH << "./lib"

require "lxc"
require "steamcmd"
require "sinatra"
require "sinatra/reloader"

post "/install/" do
  Process.detach(
    fork do
      container_name = Lxc.create(params[:name])
      Steamcmd.install_server(container_name, "4020", "/tmp/#{params[:name]}")
    end
  )
  "Creating container...\n"
end

post "/delete/" do
  Process.detach(
    fork do
      Lxc.delete(params[:name])
    end
  )
  "Deleting container...\n"
end
