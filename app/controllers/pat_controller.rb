require 'erb'

module Tamagochi
  class PatController
    def self.pat(req)
      if req.params.key?('name')
        @pat = Pat.new(name: req['name'], say: 'Hello! I`m born. ')
        page_create = ERB.new(File.read('./app/views/page.html.erb')).result(binding)
        if @pat.create
          template = ERB.new(File.read('./app/views/pat.html.erb')).result(binding)
          [201, { 'Content-Type' => 'text/html' }, [template]]
        else
          [422, { 'Content-Type' => 'text/html' }, [page_create]]
        end
      else
        [403, { 'Content-Type' => 'text/html' }, [page_create]]
      end
    end
  end
end
