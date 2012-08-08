class Artist < ActiveRecord::Base
  has_many :albums
  
  def settings_path
    "#{__FILE__}/../../sample_files/artist_#{id}_settings.json"
  end

  def self.sync_settings
    { :albums => {} }
  end
end
