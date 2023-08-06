# frozen_string_literal: true

module Warehouse
  # =class Warehouse::CargoChannel
  #
  # Warehouse::CargoChannel is a class responsible for
  # displaying current cargo data in the warehouse.
  #
  # == Usage
  # In order to use Warehouse::CargoChannel, you need to
  # subscribe to the channel in the frontend.
  #
  # @example
  #  App.cable.subscriptions.create('Warehouse::CargoChannel', {
  #    received: (data) => {
  #      console.log(data);
  #    }
  #  });
  #
  # == Broadcasting
  # In order to broadcast data to the channel, you need to call the push method.
  #
  # @example
  # Warehouse::CargoChannel.new.push({ message: 'hello', action: 'push' })
  # # => { message: 'hello', action: 'push' }
  class CargoChannel < ApplicationCable::Channel
    TARGET_CHANNEL = 'warehouse/cargo_channel'

    def subscribed
      stream_from TARGET_CHANNEL
    end

    def unsubscribed
      # Any cleanup needed when channel is unsubscribed
    end

    # #cargo fetches current slots defined in the
    # Warehouse::CurrentTimeSlotQuery
    #
    # FE call this action after connection has been established
    #
    # @return [Array<Warehouse::SlotBooking>]
    def cargo
      ActionCable.server.broadcast(TARGET_CHANNEL, cargo_query)
    end

    # #create_slot_booking creates a new slot booking
    # based on the params passed in the FE
    #
    # @param [Hash] params
    # @option params [String] :cargo_carrier_name
    # @option params [String] :started_at
    # @option params [String] :ended_at
    # @return [Warehouse::CreateSlotBookingCommand]
    def create_time_slot_booking(payload)
      cargo_command(payload).call
    end

    def push(data)
      payload = new_slot_booking_command_params(data)
      Warehouse::CreateSlotBookingCommand.new(payload).call
    end

    private

    def new_slot_booking_command_params(payload)
      year, month, day = payload['date'].split('-').map(&:to_i)
      hour, minute = payload['time'].split(':').map(&:to_i)
      started_at = DateTime.new(year, month, day, hour, minute)
      ended_at = started_at + payload['length'].to_i.minutes

      {
        cargo_carrier_name: payload['cargoCarrier'],
        started_at:,
        ended_at:
      }
    end

    def cargo_command(payload)
      @cargo_command ||= Warehouse::CreateSlotBookingCommand.new(payload)
    end

    def cargo_query
      @cargo_query ||= Warehouse::CurrentTimeSlotQuery.call
    end
  end
end
