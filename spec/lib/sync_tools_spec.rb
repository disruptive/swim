# sync_tools_spec.rb
require 'spec_helper'
require 'swim/change'
require 'swim/sync_tools'

describe SyncTools do

  context "necessary settings" do
    it "should require the object to define settings_path" do
      expect { SyncTools::compare_json_file(InvalidClass.new) }.to raise_error(
        SettingsPathMissing
      )
    end

    it "should require the object to define sync_settings" do
      expect { SyncTools::compare_json_file(AlmostValidClass.new) }.to raise_error(
        SyncSettingsMissing
      )
    end
  end

  context "compare_json_file" do
    it "should return a change when one exists" do
      artist = Artist.find(1)
      changes = SyncTools::compare_json_file(artist)
      changes.should be_an_instance_of(Array)
      changes.length.should == 1
      changes.first.should be_an_instance_of(Swim::Change)
    end

    it "should correctly identify changes" do
      artist = Artist.find(2)
      SyncTools.save_settings(artist)
      artist.albums.first.title = "The Best of Billy Prestone"
      changes = SyncTools::compare_json_file(artist)
      changes.should be_an_instance_of(Array)
      changes.length.should == 1
      changes.first.should be_an_instance_of(Swim::Change)
    end
  end

  context "#save_settings" do
    it "should save settings in a json file" do
      artist = Artist.find(2)
      expect { SyncTools.save_settings(artist) }
    end

    it "settings and object should be identical" do
      artist = Artist.find(2)
      SyncTools.save_settings(artist)
      changes = SyncTools::compare_json_file(artist)
      changes.should be_an_instance_of(Array)
      changes.length.should == 0
    end
  end

end
