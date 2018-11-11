# frozen_string_literal: true

module Tamagochi
  # class pet
  class Pet
    def initialize(req:, name:, say:, params:, ignore:)
      @req = req
      @name = name
      @say = say
      @parameters = params
      @ignore = ignore
    end

    def print_name
      @name
    end

    def parameters
      @parameters.inject(@parameters) do |hash, (key, _)|
        hash[key] = 100 if hash[key] > 100
        hash[key] = 0 if hash[key].negative?
        hash
      end
    end

    def params_ignore
      @ignore
    end

    def play
      @say = 'I like to play! '
      @parameters[:humor] += 20
      @parameters[:health] += 5
      @parameters[:appetite] -= 5
      @ignore[:ignorePlay] = 0
    end

    def eat
      if @parameters[:appetite] >= 100
        @say = 'I don`t want to eat. '
        @parameters[:humor] -= 10
      else
        @say = 'Yummy. '
        @parameters[:appetite] += 10
        @parameters[:health] += 5
        @parameters[:humor] += 5
        @parameters[:thirst] -= 10
        @ignore[:ignoreEat] = 0
      end
    end

    def drink
      if @parameters[:thirst] >= 100
        @say = 'I don`t want to drink. '
        @parameters[:humor] -= 10
      else
        @say = 'Thank you. '
        @parameters[:health] += 5
        @parameters[:humor] += 5
        @parameters[:thirst] += 10
        @ignore[:ignoreDrink] = 0
      end
    end

    def treat
      @say = 'Thank you. '
      @parameters[:health] += 50
      @parameters[:humor] += 10
      @parameters[:thirst] -= 10
      @parameters[:appetite] += 10
      @ignore.inject(@ignore) do |hash, (key, _)|
        hash[key] = 0
        hash
      end
    end

    def increment_ignore
      if @parameters[:appetite] < 100
        @say += 'I want to eat. '
        @ignore[:ignoreEat] += 1
      end
      if @parameters[:humor] < 80
        if @parameters[:humor] <= 50
          @say += 'I am ill. '
          @ignore[:ignorePlay] = 1
        else
          @say += 'I want to play. '
          @ignore[:ignorePlay] += 1
        end
      end
      if @parameters[:thirst] < 100
        @say += 'I want to drink. '
        @ignore[:ignoreDrink] += 1
      end
    end

    def check_ignore
      @parameters[:humor] -= 5 if @ignore[:ignoreEat] > 5
      @parameters[:humor] -= 5 if @ignore[:ignoreDrink] > 5
      @parameters[:humor] -= 10 if @ignore[:ignorePlay] > 5
    end

    def check
      increment_ignore
      check_ignore
      @parameters[:health] -= 10 if @parameters[:humor] <= 50
      @parameters[:health] -= 10 if @parameters[:thirst] < 50
      @parameters[:health] -= 10 if @parameters[:appetite] < 50
      @parameters[:health] -= 50 if @parameters[:humor].zero?
      @parameters[:humor] -= 10 if @parameters[:appetite] < 50
      @parameters[:humor] -= 10 if @parameters[:thirst] < 50
      parameters
    end

    def check_health
      check
      params_zero = @parameters.select { |_, value| value.zero? }
      @parameters[:health].zero? || params_zero.size > 1
    end

    def speak
      case @req.path
      when '/play' then play
      when '/eat' then eat
      when '/drink' then drink
      when '/treat' then treat
      end
      check
      @say
    end
  end
end
