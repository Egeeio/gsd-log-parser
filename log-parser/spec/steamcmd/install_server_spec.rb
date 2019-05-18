# frozen_string_literal: true

require "./lib/lxc"
require "./lib/steamcmd"

def setup
  system("lxc delete --force testdata")
  system("lxc launch ubuntu: testdata")
  sleep 5
  "testdata"
end

def tear_down
  system("lxc delete --force testdata")
end

RSpec.describe "exec" do
  it "Installs dedicated game servers" do
    container_name = setup()

    Steamcmd.install_server(container_name, "4020", "/tmp/gmod")
    gmod_dir = Lxc.exec(container_name, "stat /tmp/gmod")
    expect(gmod_dir).to include("File: /tmp/gmod")

    Steamcmd.install_server(container_name, "232250", "/tmp/tf2")
    tf2_dir = Lxc.exec(container_name, "stat /tmp/tf2")
    expect(tf2_dir).to include("File: /tmp/tf2")

    tear_down()
  end
end
