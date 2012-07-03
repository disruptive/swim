class Artist < ActiveRecord::Base
  has_many :albums
  
  def settings_file
    File.expand_path("#{__FILE__}/../../sample_files/artist_settings.json")
  end

  def self.sync_settings
    { :albums => {} }
  end
end
