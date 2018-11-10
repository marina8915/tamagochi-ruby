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
      @parameters.inject(@parameters) do |hash, (key, _)|
        hash[key] = 100 if hash[key] > 100
        hash
      end
    end

    def self.play
      @say = 'I`d like play! '
      @parameters[:appetite] -= 10
      @ignore[:ignorePlay] = 0
      check
      parameters
    end

    def self.eat
      if @parameters[:appetite] >= 100
        @say = 'I don`t want to eat. '
        @parameters[:humor] -= 10
      else
        @say = 'Yummy. '
        @parameters[:appetite] += 10
        @parameters[:health] += 10
        @parameters[:thirst] -= 10
        @ignore[:ignoreEat] = 0
      end
      check
      parameters
    end

    def self.drink
      if @parameters[:appetite] >= 100
        @say = 'I don`t want to drink. '
        @parameters[:humor] -= 10
      else
        @say = 'Thank you. '
        @parameters[:health] += 10
        @parameters[:thirst] += 10
        @ignore[:ignoreDrink] = 0
      end
      check
      parameters
    end

    def check
      if @parameters[:appetite] < 100
        @say += 'I want eat. '
        @ignore[:ignoreEat] += 1
      end
      if @parameters[:humor] < 100
        @say += 'I want play. '
        @ignore[:ignorePlay] += 1
      end
      if @parameters[:thirst] < 100
        @say += 'I want drink. '
        @ignore[:ignoreDrink] += 1
      end
      @parameters[:health] -= 10 if @parameters[:humor] < 50
      @parameters[:humor] -= 10 if @ignore[:ignoreEat] > 2
      @parameters[:humor] -= 10 if @ignore[:ignoreDrink] > 2
      @parameters[:humor] -= 10 if @ignore[:ignorePlay] > 2
    end

    def speak
      check
      @say
    end
  end
end
