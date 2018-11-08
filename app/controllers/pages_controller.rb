module Tamagochi
  class PagesController
    def self.create
      template = File.read('./app/views/page.html')
      [200, { 'Content-Type' => 'text/html' }, [template]]
    end
  end
end