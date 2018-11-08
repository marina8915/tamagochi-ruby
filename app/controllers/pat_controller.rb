module Tamagochi
  class PatController
    def self.pat(req)
      if req.params.key?('name')
        @name = Pat.new(req['name'])
        template = File.read('./app/views/pat.html')
        if @name.create
          [201, { 'Content-Type' => 'text/plain' }, ['Pat create!']]
        else
          [422, { 'Content-Type' => 'text/plain' }, ['Errors: Wrong name format.']]
        end
      else
        [403, { 'Content-Type' => 'text/plain' }, ['Missing param: name']]
      end
    end
  end
end