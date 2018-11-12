# frozen_string_literal: true

module Tamagotchi
  # class for display error pet create form
  class Error
    def initialize(display:, text:)
      @display = display
      @text = text
    end

    def display_error
      @display
    end

    def text_error
      @text
    end
  end
end
