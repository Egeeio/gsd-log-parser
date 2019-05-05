# frozen_string_literal: true

require "./lib/lxc"

def setup
  system("lxc delete --force testdata")
  system("lxc launch ubuntu: testdata")
  "testdata"
end

def tear_down
  system("lxc delete --force testdata")
end

RSpec.describe "exec" do
  it "Runs a simple command inside the container" do
    etc_hosts = Lxc.exec(setup(), "cat /etc/hosts")
    expect(etc_hosts).to include("127.0.0.1 localhost")
    tear_down()
  end

  it "Runs a complex command inside the container" do
    container_name = setup()

    Lxc.exec(container_name, "touch /opt/test_data")
    Lxc.exec(container_name, "echo 'hello world' >> /opt/test_data")
    test_file = Lxc.exec(container_name, "cat /opt/test_data")
    expect(test_file).to include("hello world")

    Lxc.exec(container_name, "rm /opt/test_data")
    removed = Lxc.exec(container_name, "cat /opt/test_data")
    expect(removed).to be_empty()

    tear_down()
  end

  it "Runs apt-get inside the container" do
    container_name = setup()

    htop_before = Lxc.exec(container_name, "which htop")
    expect(htop_before).to include("/usr/bin/htop")

    Lxc.exec(container_name, "apt-get remove -y htop")

    htop_after = Lxc.exec(container_name, "which htop")
    expect(htop_after).to be_empty()

    tear_down()
  end
end
