# frozen_string_literal: true

require 'erb'
require './app/models/error'

module Tamagotchi
  # class for the page to create a pet
  class PagesController
    def self.create
      @error = Error.new(display: false, text: '')
      template = ERB.new(File.read('./app/views/page.html.erb')).result(binding)
      [200, { 'Content-Type' => 'text/html' }, [template]]
    end
  end
end
