# tamagotchi-ruby

The game tamagotchi written in Ruby with Rack.

ruby '2.5.3'

gem 'rack', '~> 2.0', '>= 2.0.6'

### Installation

Clone repository.

    $ bundle install
    
### Usage

    $ rackup

Open http://localhost:PORT

You must enter the name of the pet.

He can say what he wants now.

You can give him to eat, to drink, to play, to put it to sleep, to awake, to treat.

Check the parameters - health, thirst, humor, appetite.
If health or 2 other parameters are 0, the pet dies.