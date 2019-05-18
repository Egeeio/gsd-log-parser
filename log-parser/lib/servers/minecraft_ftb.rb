# A class for Feed The Beast Minecraft Server
class MinecraftFtb
  attr_reader :name, :app_id
  def initialize
    @name = "ftb"
    @app_id = nil
  end

  def launch(install_path)
    "cd #{install_path} && /bin/bash #{install_path}/ServerStart.sh"
  end

  def install_server(install_path)
    system("wget https://media.forgecdn.net/files/2658/240/FTBRevelationServer_2.7.0.zip -O /tmp/server.zip")
    system("mkdir #{install_path}")
    system("unzip /tmp/server.zip -d#{install_path}")
    system("chmod +x #{install_path}/ServerStart.sh")
    system("chmod +x #{install_path}/FTBInstall.sh")
    system("/bin/bash #{install_path}/FTBInstall.sh")
    system("rm #{install_path}/eula.txt")
    system("echo eula=true > #{install_path}/eula.txt")
  end
end
