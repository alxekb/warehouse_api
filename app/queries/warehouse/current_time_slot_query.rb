# frozen_string_literal: true

module Warehouse
  # =class Warehouse::CurrentTimeSlotQuery
  #
  # CurrentTimeSlotQuery is a class that returns the current time slots for a given day.
  #
  # @example
  #  Warehouse::CurrentTimeSlotQuery.new(date: DateTime.today).call
  #  # => [#<SlotBooking id: 1, started_at: "2021-08-01 00:00:00", ended_at: "...">]
  class CurrentTimeSlotQuery
    attr_reader :date

    def self.call(**args, &block)
      new(**args, &block).call
    end

    def initialize(date: DateTime.now)
      @date = date
    end

    def call
      SlotBooking
        .order(:started_at, :desc)
        .where('started_at <= ? AND ended_at >= ?', date + 2.day, date)
    end
  end
end
