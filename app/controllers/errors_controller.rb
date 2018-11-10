# frozen_string_literal: true

module Tamagochi
  # class for output error for non-existent pages
  class ErrorsController
    def self.not_found
      [404, { 'Content-Type' => 'text/plain' }, ['Not found']]
    end
  end
end
