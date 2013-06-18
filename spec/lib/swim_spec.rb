require 'spec_helper'
require 'swim'

describe Swim do
  it 'should return correct version string' do
    Swim.version_string.should == "Swim version #{Swim::VERSION}"
  end
end
