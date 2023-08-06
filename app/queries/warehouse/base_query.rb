# frozen_string_literal: true

module Warehouse
  # =class Warehouse::BaseQuery
  #
  # Base class for all queries
  #
  # @example
  #  class MyQuery < Warehouse::BaseQuery
  #    def call
  #      # do something
  #    end
  #  end
  #
  #  MyQuery.call
  class BaseQuery # :nodoc:
    def self.call(**args, &block)
      new(**args, &block).call
    end

    def call
      raise NotImplementedError
    end
  end
end
