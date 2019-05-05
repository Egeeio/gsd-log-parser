# frozen_string_literal: true

class HelloController < ApplicationController
  def world
    system('lxc list')
  end
end
