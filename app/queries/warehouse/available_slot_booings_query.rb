# frozen_string_literal: true

module Warehouse
  # =class Warehouse::AvailableSlotBookingsQuery
  #
  # AvailableSlotBookingsQuery is a class that returns a list of available slot bookings.
  #
  # @example
  #  Warehouse::AvailableSlotBookingsQuery.new.call
  #  # => [#<SlotBooking id: 1, cargo_carrier_name: "Cargo Carrier",
  #                      started_at: "2021-08-01 00:00:00", ended_at: "...">]
  class AvailableSlotBookingsQuery < BaseQuery
    # Returns a list of available slot bookings.
    # @return [Array<SlotBooking>]
    def call
      SlotBooking.where('started_at >= ? AND ended_at <= ?',
                        date + 1.day,
                        date + 1.week)
    end
  end
end
