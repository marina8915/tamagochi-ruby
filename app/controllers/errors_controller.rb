module Tamagochi
  class ErrorsController
    def self.not_found
      [404, { 'Content-Type' => 'text/plain' }, ['Not found']]
    end
  end
end