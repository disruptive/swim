# sync_tools_spec.rb
require 'spec_helper'
require 'swim/change'
require 'swim/sync_tools'

class AlmostValidClass
  def settings_file
    File.expand_path("#{__FILE__}/../../sample_files/almost_valid_class_settings.json")
  end
  
  # def self.sync_settings
  #   return Hash.new
  # end
end

class InvalidClass
  # def self.settings_file
  #   return Hash.new
  # end
  # def self.sync_settings
  #   return Hash.new
  # end
end

describe SyncTools do
  
  it "should require the object to define settings_file" do
    i_class = InvalidClass.new
    expect { SyncTools::compare_json_file(i_class) }.to raise_error(
      SettingsFileMissing
    )
  end
  
  it "should require the object to define sync_settings" do
    i2_class = AlmostValidClass.new
    expect { SyncTools::compare_json_file(i2_class) }.to raise_error(
      SyncSettingsMissing
    )
  end

  it "should return a change when one exists" do
    artist = Artist.find(1)
    changes = SyncTools::compare_json_file(artist)
    changes.should be_an_instance_of(Array)
    changes.length.should == 1
    changes.first.should be_an_instance_of(Swim::Change)
  end   

end
