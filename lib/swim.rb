require 'multi_json' unless RUBY_VERSION >= "1.9.3"

module Swim
  require "swim/version"
  require "swim/change"
  require "swim/sync_tools"

  def self.version_string
    return "Swim version #{Swim::VERSION}"
  end
end
