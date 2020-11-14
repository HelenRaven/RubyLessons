# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validations

    def validate(attr_name, validation, *args)
      @validations ||= []
      @validations.push({ attr: attr_name, type: "valid_#{validation}".to_sym, options: args })
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |valid_hash|
        send(valid_hash[:type], "@#{valid_hash[:attr]}".to_sym, valid_hash[:options][0])
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
