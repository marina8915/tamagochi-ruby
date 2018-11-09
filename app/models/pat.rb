module Tamagochi
  class Pat
    def initialize(name)
      @name = name
      @parameters = { appetite: 80, health: 100, humor: 100, thirst: 80 }
      @ignore = { ignoreEat: 0, ignoreDrink: 0, ignorePlay: 0, ignoreSleep: 0 }
    end

    def create
      @name.size.positive? ? true : false
    end

    def print_name
      @name
    end
  end
end
