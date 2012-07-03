class Swim::Change
  attr_accessor :obj_class, :obj_id, :change_type, :key, :old_value, :new_value, :status, :errors
    
  def initialize(args)
    obj_class = args[:obj_class]
    obj_id      = args[:obj_id]
    change_type = args[:change_type]
    key         = args[:key]
    old_value   = args[:old_value]
    new_value   = args[:new_value]
    status      = args[:status]
    errors      = args[:errors]
  end
    
  def new(args)
  end
    
  def item
    obj_class.constantize.send(:find, obj_id)
  end
    
  def update(i)
    i.update_attribute(key, new_value)
  end
    
  def delete(i)
    i.destroy
  end
    
  def insert
    i = obj_class.constantize.send(:new, new_value)
    return i
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
end
