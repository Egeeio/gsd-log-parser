# frozen_string_literal: true

$LOAD_PATH << "./lib"
$LOAD_PATH << "./conf"

require "server_lookup"
require "sinatra"
require "sinatra/reloader"

post "/install/" do
  Process.detach(
    fork do
      ServerLookup.servers[params[:name]].install(Lxc.create(params[:name]))
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
