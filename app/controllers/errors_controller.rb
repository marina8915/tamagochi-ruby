# frozen_string_literal: true

module Tamagochi
  # class for output error for non-existent pages
  class ErrorsController
    def self.not_found
      [404, { 'Content-Type' => 'text/html' }, ['<h1>Not found</h1>']]
    end
  end
end
