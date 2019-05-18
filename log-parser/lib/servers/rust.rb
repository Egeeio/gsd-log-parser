# Create a Rust server
class Rust
  attr_reader :name, :app_id
  def initialize
    @name = "rust"
    @app_id = "258550"
  end

  def launch(install_path, password = "_", ip = "0.0.0.0", port = "28015")
    "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:#{install_path}/RustDedicated_Data/Plugins/x86_64 &&
    cd #{install_path} &&
    ./RustDedicated +server.ip #{ip} +server.port #{port} +server.identity rust +rcon.web 1 \
    +rcon.ip #{ip} \
    +rcon.port 28016 \
    +rcon.password #{password}"
  end
end
