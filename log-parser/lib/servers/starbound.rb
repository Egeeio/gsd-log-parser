# A module to produce resources for a Starbound server
class Starbound
  attr_reader :name, :app_id
  def initialize
    @name = "starbound"
    @app_id = "533830"
  end

  def launch(install_path)
    "cd #{install_path}/linux &&
    #{install_path}/linux/starbound_server"
  end
end
