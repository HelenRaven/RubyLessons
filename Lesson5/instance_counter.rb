module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods

    def zeroize_instances
      self.all_instances = 0
    end

    def increase_instances
      self.all_instances += 1
    end

    def instances
      self.all_instances
    end

    protected
    attr_accessor :all_instances

  end

  module InstanceMethods

    protected
    def register_instance
      self.class.zeroize_instances if self.class.instances == nil
      self.class.increase_instances
    end

  end

end