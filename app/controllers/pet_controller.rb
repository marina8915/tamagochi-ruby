# frozen_string_literal: true

require 'erb'
require 'time'
require './app/models/pet'
require './app/models/error'

module Tamagotchi
  # class PetController for model Pat
  class PetController
    def self.pet(req)
      if req.params.key?('name')
        @pet_name = req['name'] || ''
        @pet = Pet.new(req: req, name: @pet_name,
                       params: { appetite: 80, health: 100,
                                 humor: 100, thirst: 90 },
                       ignore: { ignoreEat: 0, ignoreDrink: 0,
                                 ignorePlay: 0, ignoreSleep: 0 },
                       time: Time.now, dreams: false)
        # check if @pet_name less then 5 characters then create error
        if @pet_name.delete(' ').size >= 5
          template = ERB.new(File.read('./app/views/pet.html.erb')).result(binding)
          [201, { 'Content-Type' => 'text/html' }, [template]]
        else
          text_error = 'The name must contain at least 5 characters.'
          @error = Error.new(display: true, text: text_error)
          page_create = ERB.new(File.read('./app/views/page.html.erb')).result(binding)
          [422, { 'Content-Type' => 'text/html' }, [page_create]]
        end
      end
    end

    # method action for create, play, eat, drink, sleep, awake
    def self.action(req)
      @pet = Pet.new(req: req, name: @pet_name,
                     params: @pet.parameters, ignore: @pet.params_ignore,
                     time: @pet.attr_reader_time, dreams: @pet.attr_reader_dreams)
      if @pet.check_health
        @error = Error.new(display: true, text: 'Your pet die.')
        page_create = ERB.new(File.read('./app/views/page.html.erb')).result(binding)
        [201, { 'Content-Type' => 'text/html' }, [page_create]]
      else
        template = ERB.new(File.read('./app/views/pet.html.erb')).result(binding)
        [201, { 'Content-Type' => 'text/html' }, [template]]
      end
    end
  end
end
