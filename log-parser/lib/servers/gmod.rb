# frozen_string_literal: true

require ""

# A module to produce resources for a Garry's Mod server
class GarrysMod
  attr_reader :name, :app_id
  def initialize
    @name = "gmod"
    @app_id = "4020"
    @install_path = "/root/gmod"
  end

  def bootstrap
    "cd #{@install_path} &&
    #{@install_path}/srcds_run \
    -console \
    -game garrysmod \
    +map gm_construct \
    +maxplayers 16 \
    +host_workshop_collection 1270037458 \
    -condebug & \
    /usr/bin/tail -f #{@install_path}/garrysmod/console.log"
  end

  def install
    system("touch #{@install_path}/garrysmod/console.log")
  end
end
