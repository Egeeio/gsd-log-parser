# frozen_string_literal: true

# Interacting with lxc container
module Lxc
  def self.create(name)
    system("lxc launch ubuntu: #{name}") if `lxc list`.include?(name) == false
    sleep 10
    name
  end

  def self.delete(name)
    system("lxc delete -f #{name}") if `lxc list`.include?(name)
  end

  # Use when you need to return the output of the command
  def self.exec(container_name, command)
    `lxc exec #{container_name} -- bash -c "#{command}"`
  end

  # Use when you need a psudo-tty. Only returns a boolean
  def self.exec_tty(container_name, command)
    system("lxc exec #{container_name} -- bash -c '#{command}'")
  end
end
