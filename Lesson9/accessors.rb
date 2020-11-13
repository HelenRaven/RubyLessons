# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym

      define_method("#{name}=".to_sym) do |value|
        if instance_variable_get(var_name)
          instance_variable_get(var_name).push(value)
        else
          instance_variable_set(var_name, [value])
        end
      end

      define_method(name.to_sym) { instance_variable_get(var_name)&.last }

      define_method("#{name}_history".to_sym) { instance_variable_get(var_name) }
    end
  end

  def strong_attr_accessor(name, var_class)
    var_name = "@#{name}".to_sym
    define_method(name.to_sym) { instance_variable_get(var_name) }

    define_method("#{name}=".to_sym) do |value|
      raise "Wrong value class! Given #{value.class} Required #{var_class}" unless value.instance_of?(var_class)

      instance_variable_set(var_name, value)
    end
  end
end
