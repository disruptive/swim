require 'multi_json'

module Swim
  require "swim/version"
  require "swim/change"
  require "swim/sync_tools"
  
  def self.version_string
    return "Swim version #{Swim::VERSION}"
  end
end
