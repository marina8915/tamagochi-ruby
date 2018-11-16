# frozen_string_literal: true

require 'time'

module Tamagotchi
  # class pet can read parameters - name, time, dreams, parameters, ignore
  # methods for action - play, sleep, awake, eat, drink, treat
  # methods for check and change parameters: increment_ignore, check_ignore, check
  # method check_health to check if the animal is still alive
  # check_time_sleep to check whether it's time for a pet to sleep
  # speak - redirect to action depending on the path, displays the Pet`s words
  # reset_ignore - assign 0 for everyone of hash ignore parameter
  class Pet
    def initialize(req:, name:, params:, ignore:, time:, dreams:)
      # current url
      @req = req.path
      @name = name
      @say = ''
      # hash with key - appetite, health, humor, thirst
      @parameters = params
      # hash with key eat, drink, play, sleep
      @ignore = ignore
      # the time when the animal was created or the last awake
      @time = time
      # boolean parameter that indicates that the pet is sleeping or not
      @dreams = dreams
    end

    attr_reader :name, :time, :dreams, :ignore

    def parameters
      # check if the values are more than 100 or less than 0  => reassign value
      @parameters.each_with_object(@parameters) do |(key, _), hash|
        hash[key] = 100 if hash[key] > 100
        hash[key] = 0 if hash[key].negative?
      end
    end

    def play
      @say = 'I like to play! '
      @parameters[:humor] += 20
      @parameters[:health] += 5
      @parameters[:appetite] -= 5
      @ignore[:play] = 0
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
        @ignore[:eat] = 0
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
        @ignore[:drink] = 0
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
      reset_ignore
      @parameters.each_with_object(@parameters) do |(key, _), hash|
        hash[key] += 20
      end
    end

    def awake
      @time = Time.now
      @say = 'Good morning! '
      @dreams = false
      increment_ignore
      time
    end

    def check_time_sleep(period)
      Time.now - @time >= period
    end

    # all ignore = 0
    def reset_ignore
      @ignore.each_with_object(@ignore) do |(key, _), hash|
        hash[key] = 0
      end
    end

    def increment_ignore
      if @parameters[:appetite] < 100
        @say += 'I want to eat. '
        @ignore[:eat] += 1
      end
      if check_time_sleep(20)
        @say += 'I am tired. '
        @ignore[:sleep] += 1
      end
      if @parameters[:humor] < 80 || @parameters[:health] < 80
        if @parameters[:health] <= 50 || @parameters[:humor] <= 50
          @say += 'I am ill. '
        elsif check_ignore.size.zero?
          @say += 'I want to play. '
          @ignore[:play] += 1
        end
      end
      if @parameters[:thirst] < 100
        @say += 'I want to drink. '
        @ignore[:drink] += 1
      end
    end

    def check_ignore
      ignore
      @ignore.select { |_, value| value >= 5 }
    end

    def check
      little_params = @parameters.select { |_, value| value.zero? || value <= 50 }
      @parameters[:health] -= 10 if little_params.size.positive? || little_params.size > 1
      @parameters[:humor] -= 10 if @parameters[:appetite] < 50 || @parameters[:thirst] < 50

      big_ignore = check_ignore
      @parameters[:humor] -= 5 if big_ignore.size.positive?
      @parameters[:health] -= 10 if big_ignore.size > 1

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
