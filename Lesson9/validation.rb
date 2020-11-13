# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(attr_name, validation, *args)
      var_name = '@valids'.to_sym
      instance_variable_set(var_name, {}) unless instance_variable_get(var_name)

      if instance_variable_get(var_name)[attr_name]
        instance_variable_get(var_name)[attr_name]["valid_#{validation}".to_sym] = args
      else
        instance_variable_get(var_name)[attr_name] = { "valid_#{validation}".to_sym => args }
      end
    end
  end

  module InstanceMethods
    def validate!
      self.class.instance_variable_get('@valids'.to_sym).each do |attr_name, arg_hash|
        arg_hash.each do |validation, args|
          send(validation, "@#{attr_name}".to_sym, args[0])
        end
      end
    end

    private

    def valid_presence(attr_name, *_args)
      value = instance_variable_get(attr_name)
      raise "Argument #{attr_name} can't be nil or empty string!" if value.nil? || value.equal?('')
    end

    def valid_format(attr_name, *args)
      value = instance_variable_get(attr_name)
      raise "Wrong argument #{attr_name} format!" if value !~ args[0]
    end

    def valid_type(attr_name, *args)
      value = instance_variable_get(attr_name)
      raise "Wrong argument #{attr_name} class! Required #{args[0]}" unless value.instance_of?(args[0])
    end

    def valid_positive(attr_name, *_args)
      value = instance_variable_get(attr_name)
      raise "Argument #{attr_name} must be > 0!" unless value.positive?
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end
  end
end
