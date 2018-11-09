module Tamagochi
  class Pat
    def initialize(name:, say:)
      @name = name
      @display = true
      @say = say
      @parameters = { appetite: 80, health: 100, humor: 100, thirst: 80 }
      @ignore = { ignoreEat: 0, ignoreDrink: 0, ignorePlay: 0, ignoreSleep: 0 }
    end

    def create
      @name.size.positive? ? true : false
    end

    def print_name
      @name
    end

    def parameters
      @parameters
    end

    def pat_say
      @say += 'I want eat. ' if parameters[:appetite] < 100
      @say += 'I want play. ' if parameters[:humor] < 100
      @say += 'I want drink. ' if parameters[:thirst] < 100
    end
  end
end
