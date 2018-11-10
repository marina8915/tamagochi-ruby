# frozen_string_literal: true

require 'erb'

module Tamagochi
  # class for the page to create a pet
  class PagesController
    def self.create
      template = ERB.new(File.read('./app/views/page.html.erb')).result(binding)
      [200, { 'Content-Type' => 'text/html' }, [template]]
    end
  end
end
