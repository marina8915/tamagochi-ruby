module Tamagochi
  class Pat
    def initialize(name)
      @name = name
    end

    def create
      @name.size.positive? ? true : false
    end
  end
end