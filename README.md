# Swim

Swim provides tools for synchronizing a tree of ActiveRecord objects with a previously-saved JSON file.

## Installation

Add this line to your application's Gemfile:

    gem 'swim'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install swim

## Usage

1. Add a settings_file instance method to your ActiveRecord class.

		class Artist < ActiveRecord::Base
			def settings_file
				File.expand_path("/sample_files/artist_1_settings.json")
			end
		end
	
2. Add a sync_settings class method to your ActiveRecord class.

		class Artist < ActiveRecord::Base
		  def self.sync_settings
		    { :albums => {} }
		  end
		end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
