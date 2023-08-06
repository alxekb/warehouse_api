# frozen_string_literal: true

class CreateSlotBookings < ActiveRecord::Migration[7.0] # :nodoc:
  def change
    create_table :slot_bookings do |t|
      t.string :cargo_carrier_name

      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end
  end
end
