# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base # :nodoc:
    DEFAULT_CARGO_CARRIER_NAME = 'unknown cargo carrier'
    identified_by :cargo_carrier_name

    def connect
      self.cargo_carrier_name = session_cargo_carrier_name

      reject_unauthorized_connection unless cargo_carrier_name
    end

    private

    def session_cargo_carrier_name
      @session_cargo_carrier_name ||= request.session.fetch(:cargo_carrier_name, DEFAULT_CARGO_CARRIER_NAME)
    end
  end
end
