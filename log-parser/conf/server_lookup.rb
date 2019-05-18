# frozen_string_literal: true

require "servers"

module ServerLookup
  def self.servers
    {
      "rust" => Rust.new,
      "sdtd" => SevenDays.new,
      "gmod" => GarrysMod.new,
      "aos" => AceOfSpades.new,
      "tf2" => TeamFortress.new,
      "ftb" => MinecraftFtb.new,
      "terraria" => Terraria.new,
      "starbound" => Starbound.new,
      "minecraft" => MinecraftSpigot.new
    }
  end
end
