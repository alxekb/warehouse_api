# frozen_string_literal: true

module Warehouse
  # =class Warehouse::SlotBooking
  #
  # SlotBooking is a model that represents a slot booking.
  #
  # == Schema Information
  #
  # Table name: slot_bookings
  #
  # id                  :uuid             not null, primary key
  # cargo_carrier_name  :string
  # started_at          :date
  # ended_at            :date
  # created_at          :datetime         not null
  # updated_at          :datetime         not null
  #
  # =Indexes
  #
  # index_slot_bookings_on_cargo_carrier_name  (cargo_carrier_name)
  #
  # @example
  #  Warehouse::SlotBooking.new
  #
  #  # => #<SlotBooking id: nil, cargo_carrier_name: nil, started_at: nil,
  #                     ended_at: nil, created_at: nil, updated_at: nil>
  class SlotBooking < ApplicationRecord
    # @!attribute [rw] cargo_carrier_name
    #  @return [String] the cargo carrier name
    # @!attribute [rw] started_at
    # @return [DateTime] the start date of the slot booking
    # @!attribute [rw] ended_at
    # @return [DateTime] the end date of the slot booking

    DEFAULT_CARRIER_NAME = 'Bogus'

    validates_with SlotBookingValidator

  end
end
