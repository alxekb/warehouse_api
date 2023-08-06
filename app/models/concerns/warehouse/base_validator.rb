# frozen_string_literal: true

module Warehouse
  # =class Warehouse::BaseValidator
  #
  # Base class for all validators for the Warehouse application.
  #
  # == Usage
  #  class MyValidator < Warehouse::BaseValidator
  #    def validate(record)
  #      record.errors.add(:base, 'error message') if record.field == 'value'
  #    end
  #  end
  class BaseValidator < ActiveModel::Validator
    # Validates the record.
    #
    # @param record [ActiveRecord::Base] the record to validate
    def validate(record)
      raise NotImplementedError
    end
  end
end
