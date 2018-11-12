# frozen_string_literal: true

require 'time'

module Tamagotchi
  # class pet can read parameters - name, time, dreams, parameters, params_ignore
  # methods for action - play, sleep, awake, eat, drink, treat
  # methods for check and change parameters: increment_ignore, check_ignore, check
  # method check_health to check if the animal is still alive
  # check_time_sleep to check whether it's time for a pet to sleep
  # speak - redirect to action depending on the path, displays the words of the pet
  # reset_ignore - assign 0 for everyone of hash ignore parameter
  class Pet
    def initialize(req:, name:, params:, ignore:, time:, dreams:)
      # current url
      @req = req.path
      @name = name
      @say = ''
      # hash with key - appetite, health, humor, thirst
      @parameters = params
      # hash with key ignoreEat, ignoreDrink, ignorePlay, ignoreSleep
      @ignore = ignore
      # the time when the animal was created or the last awake
      @time = time
      # boolean parameter that indicates that the pet is sleeping or not
      @dreams = dreams
    end

    def attr_reader_name
      @name
    end

    def attr_reader_time
      @time
    end

    def attr_reader_dreams
      @dreams
    end

    def parameters
      # check if the values are more than 100 or less than 0  => reassign value
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
      check
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
      check
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
      check
    end

    def treat
      @say = 'Thank you. '
      @parameters[:health] += 50
      @parameters[:humor] += 10
      @parameters[:thirst] -= 10
      @parameters[:appetite] += 10
      reset_ignore
      check
    end

    def sleep
      @say = 'zzZ'
      @dreams = true
      @ignore[:ignoreSleep] = 0
    end

    def awake
      @time = Time.now
      @say = 'Good morning! '
      reset_ignore
      @parameters.inject(@parameters) do |hash, (key, _)|
        hash[key] += 20
        hash
      end
      @dreams = false
      check
    end

    def check_time_sleep(period)
      result = Time.now - @time >= period
      @ignore[:ignoreSleep] += 1 if result
      check
      result
    end

    # all ignore = 0
    def reset_ignore
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
      @say += 'I am ill. ' if @parameters[:health] <= 50 || @parameters[:humor] <= 50
      if @parameters[:humor] < 80
        if @ignore[:ignoreSleep] >= 1
          @say += 'I am tired.'
          @ignore[:ignoreSleep] += 1
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
      @parameters[:humor] -= 5 if @ignore[:ignoreEat] >= 5
      @parameters[:humor] -= 5 if @ignore[:ignoreDrink] >= 5
      @parameters[:humor] -= 10 if @ignore[:ignorePlay] >= 5
      @parameters[:health] -= 10 if @ignore[:ignoreSleep] >= 5
    end

    def check
      @parameters[:health] -= 10 if @parameters[:humor] <= 50
      @parameters[:health] -= 10 if @parameters[:thirst] < 50
      @parameters[:health] -= 10 if @parameters[:appetite] < 50
      @parameters[:health] -= 50 if @parameters[:humor].zero?
      @parameters[:humor] -= 10 if @parameters[:appetite] < 50
      @parameters[:humor] -= 10 if @parameters[:thirst] < 50
      check_ignore
      increment_ignore
      parameters
    end

    def check_health
      check
      params_zero = @parameters.select { |_, value| value.zero? }
      @parameters[:health].zero? || params_zero.size > 1
    end

    def speak
      case @req
      when '/pet' then @say = 'Hello! I`m born. '; check
      when '/play' then play
      when '/eat' then eat
      when '/drink' then drink
      when '/treat' then treat
      when '/sleep' then sleep
      when '/awake' then awake
      end
      @say
    end
  end
end
