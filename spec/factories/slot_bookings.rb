# frozen_string_literal: true

FactoryBot.define do
  factory :slot_booking, class: Warehouse::SlotBooking.name do
    cargo_carrier_name { 'Maersk' }
    started_at { Date.today }
    ended_at { Date.today + 1.day }
  end
end
