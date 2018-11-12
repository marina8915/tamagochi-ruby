# frozen_string_literal: true

require './app/application'

run Rack::Cascade.new([Rack::File.new('public'), Tamagotchi::Application])
