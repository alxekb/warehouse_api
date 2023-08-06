# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Warehouse::CreateSlotBookingCommand do
  subject(:command) { described_class.new(slot_booking_params) }
  let(:cargo_carrier_name) { 'Bogus' }
  let(:started_at) { (DateTime.now + 1.day + 1.hour).to_s }
  let(:ended_at) { (DateTime.now + 1.day + 2.hours).to_s }
  let(:slot_booking_params) do
    {
      cargo_carrier_name:,
      started_at:,
      ended_at:
    }
  end

  describe '#call' do
    context 'when payload is valid' do
      it 'has no errors' do
        expect(command.call.errors).to be_empty
      end

      it 'returns self' do
        expect(command.call).to eq(command)
      end
    end

    it 'creates a slot booking' do
      expect { command.call }.to change { Warehouse::SlotBooking.count }.by(1)
    end
  end
end
