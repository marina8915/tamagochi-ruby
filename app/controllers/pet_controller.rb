require 'erb'
require './app/models/pet'

module Tamagochi
  # class PetController for model Pat action create, play, eat, drink
  class PetController
    def self.pet(req)
      if req.params.key?('name')
        @pet_name = req['name']
        @pet = Pet.new(req: req,
                       name: @pet_name,
                       say: 'Hello! I`m born. ',
                       params: { appetite: 80, health: 100,
                                 humor: 100, thirst: 80 },
                       ignore: { ignoreEat: 0, ignoreDrink: 0,
                                 ignorePlay: 0, ignoreSleep: 0 })
        page_create = ERB.new(File.read('./app/views/page.html.erb')).result(binding)
        if @pet.create
          template = ERB.new(File.read('./app/views/pet.html.erb')).result(binding)
          [201, { 'Content-Type' => 'text/html' }, [template]]
        else
          [422, { 'Content-Type' => 'text/html' }, [page_create]]
        end
      else
        [403, { 'Content-Type' => 'text/html' }, [page_create]]
      end
    end

    def self.action(req)
      @pet = Pet.new(req: req, name: @pet_name, say: '',
                     params: @pet.parameters, ignore: @pet.params_ignore)
      template = ERB.new(File.read('./app/views/pet.html.erb')).result(binding)
      [201, { 'Content-Type' => 'text/html' }, [template]]
    end
  end
end
