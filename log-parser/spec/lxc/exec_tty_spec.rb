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
