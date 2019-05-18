# frozen_string_literal: true

# Create a 7 Days to Die server
class SevenDays
  attr_reader :name, :app_id
  def initialize
    @name = "sdtd"
    @app_id = "294420"
  end

  def launch(install_path)
    "cd #{install_path} &&
    export LD_LIBRARY_PATH=. &&
    #{install_path}/7DaysToDieServer.x86_64 \
    -logfile #{install_path}/server.log \
    -quit \
    -batchmode \
    -nographics \
    -dedicated \
    -configfile=#{install_path}/serverconfig.xml & \
    /usr/bin/tail -f #{install_path}/server.log"
  end

  def post_install(install_path)
    system("touch #{install_path}/server.log") # TODO: This won't scale
  end
end
