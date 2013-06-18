# Class to store changes made during SyncTools' import_json_file method.
class Swim::Change
  attr_accessor :obj_class, :obj_id, :change_type, :key, :old_value, :new_value, :status, :errors

  def initialize(attributes = nil)
    self.obj_class   = attributes[:obj_class]
    self.obj_id      = attributes[:obj_id]
    self.change_type = attributes[:change_type]
    self.key         = attributes[:key]
    self.old_value   = attributes[:old_value]
    self.new_value   = attributes[:new_value]
    self.status      = attributes[:status]
    self.errors      = attributes[:errors]
  end

  def to_s
    if status.nil? || status.empty?
      verb = "would be"
    elsif status == "succeeded"
      verb = "was"
    elsif status == "failed"
      verb = "could not be"
    end
    if change_type == :update
      "#{obj_class}(#{obj_id})##{key} #{verb} #{old_value} (instead of #{new_value})."
    else
      "#{obj_class}(#{obj_id}) #{verb} #{change_type}d (#{ change_type == :insert ? new_value.to_hash : old_value.to_hash })."
    end
  end

  def new(args)
  end

  def process
    if change_type == :update
      i = item
      status = update(i) ? "succeeded" : "failed"
    elsif change_type == :delete
      i = item
      status = delete(i) ? "succeeded" : "failed"
    elsif change_type == :insert
      i = insert
      if insert.save
        status = "succeeded"
      else
        errors = i.errors
        status = "failed"
      end
    end
    if status == "succeeded"
      return true
    else
      errors = item.errors
      return false
    end
  end

  private

  # Convenience method for accessing the changed object in the database
  def item
    obj_class.constantize.send(:find, obj_id)
  end

  # Method to execute the attribute update described by the Change
  def update(i)
    i.update_attribute(key, new_value)
  end

  # Method to execute the object deletion described by the Change
  def delete(i)
    i.destroy
  end

  # Method to execute the object insertion described by the Change
  def insert
    i = obj_class.constantize.send(:new, new_value)
    return i
  end
end
