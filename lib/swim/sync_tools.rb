require 'active_support/all'

class SyncSettingsMissing < StandardError
end

class SettingsFileMissing < StandardError
end


class SyncTools
    
  def self.json_file(settings_filename)
    file = File.open(settings_filename, "rb")
    contents = file.read
    ActiveSupport::JSON.decode(contents)
  end
    
  def self.compare_json_file(obj)    
    unless obj.methods.include?(:settings_file) || obj.methods.include?('settings_file')
      raise SettingsFileMissing, "#{obj.class.to_s} must define a class method named settings_file."
    end
    json = json_file(obj.settings_file)
    
    unless obj.class.methods.include?(:sync_settings) || obj.class.methods.include?("sync_settings")
      raise SyncSettingsMissing, "#{obj.class.to_s} must define a class method named sync_settings that returns a hash."
    end
    
    if json[obj.class.to_s.underscore].class.to_s == "Hash"
      return compare(obj, json[obj.class.to_s.underscore], obj.class.sync_settings)
    else
      return compare(obj, json, obj.class.sync_settings)
    end
  end
    
  def self.import_json_file(obj, settings_filename)
    changes = Swim::SyncTools.compare_json_file(self, settings_file)
    completed = []
    not_completed = []
    changes.each do |ch|
      oc = ch.process
      if oc
        completed << ch
      else
        not_completed << ch
      end
    end
    return { :status => (not_completed.length > 0 ? "incomplete" : "complete"), :changed => completed, :not_completed => not_completed }
  end
	
  def self.compare(obj, hsh, settings) 
    @changes = []
    if settings.present? && settings[:include]
      settings[:include].keys.each do |sk|
        compare_array(obj.send(sk), hsh[sk.to_s], settings[sk], sk)
      end      
    elsif settings.present? && settings.keys
      settings.keys.each do |sk|
        compare_array(obj.send(sk), hsh[sk.to_s], settings[sk.to_sym], sk)
      end
    end

    obj.attributes.each_pair do |key, value|
      hsh_value = hsh[key]
      if value.class == Time && hsh_value.class == String
        hsh_value = Time.parse(hsh_value).utc.to_s
        value = value.utc.to_s
      elsif hsh_value.class == Time && value.class == String
        hsh_value = hsh_value.utc.to_s
        value = Time.parse(value).utc.to_s
      elsif hsh_value.class == Time && value.class == Time
        hsh_value = hsh_value.utc.to_s
        value = value.utc.to_s
      end
      unless value == hsh_value
        @changes << Swim::Change.new(:obj_class => obj.class.to_s, :obj_id => obj.id, :change_type => :update, :key => key, :old_value => value, :new_value => hsh_value)
      else
        # p "#{obj.class.to_s} #{key} #{value} == #{hsh_value}"
      end
    end
    return @changes
  end
  
  def self.compare_array(arr, hsh, settings, obj_classname)
    if arr.length == 0 && hsh.nil?
      return
    elsif hsh.nil?
      throw "Array (#{arr.collect{|ar| ar.class.to_s }}) has no hash for comparison"
    end
    hsh_members = hsh.collect{ |h| h["id"] }
    arr.each do |a|
      x = hsh.select{ |h| h if h["id"] == a.id }[0]
      hsh_members.delete(x["id"])
      if x.nil? || x.empty?
        @changes << Change.new(:obj_class => a.class.to_s.singularize.capitalize, :obj_id => a.id, :change_type => :delete)
      else
        compare(a, x, settings)
      end
    end
    if hsh_members.length > 0
      hsh_members.each do |hm|
        @changes << Change.new(:obj_class => obj_classname.to_s.singularize.capitalize, :obj_id => hm, :change_type => :insert, :new_value => hsh.select{ |h| h if h["id"] == hm }[0].to_json)
      end
    end
  end
		
end
