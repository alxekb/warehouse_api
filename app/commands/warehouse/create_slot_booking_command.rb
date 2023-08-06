# frozen_string_literal: true

module Warehouse
  # =class Warehouse::CreateSlotBookingCommand
  #
  # CreateSlotBookingCommand is a class responsible for creating a slot booking.
  #
  # @example
  #  Warehouse::CreateSlotBookingCommand.new.call(
  #    cargo_carrier_name: 'DHL',
  #    started_at: '2019-01-01:00:00:00',
  #    ended_at: '2019-01-01:00:00:00'
  #  )
  #  # => #<SlotBooking id: nil, cargo_carrier_name: 'DHL',
  #  started_at:  '2019-01-01:00:00:00', ended_at: '2019-01-01:00:00:00',
  #  created_at: ..., updated_at: ...>
  class CreateSlotBookingCommand
    attr_reader :success

    def initialize(payload)
      @payload = payload
      @success = false
      @errors = []
    end

    # =Happy path only
    #
    # No error handling for now.
    def call
      save && @success = true

      errors.blank? && notify? && broadcast

      self
    end

    def errors
      puts booking.errors.full_messages
      booking.errors
    end

    private

    attr_reader :payload, :validator

    def save
      booking.save
    end

    def notify?
      success
    end

    def booking
      @booking ||= Warehouse::SlotBooking.new(slot_booking_payload)
    end

    def broadcast
      ActionCable.server.broadcast(
        Warehouse::CargoChannel::TARGET_CHANNEL,
        broadcast_attributes
      )
    end

    def broadcast_attributes
      {
        attributes: booking.attributes,
        type: :append
      }
    end

    def slot_booking_payload
      {
        cargo_carrier_name:,
        started_at:,
        ended_at:
      }
    end

    def started_at
      @started_at ||= payload[:started_at]
    end

    def ended_at
      @ended_at ||= payload[:ended_at]
    end

    def cargo_carrier_name
      @cargo_carrier_name ||=
        payload[:cargo_carrier_name].presence ||
        Warehouse::SlotBooking::DEFAULT_CARRIER_NAME
    end
  end
end
