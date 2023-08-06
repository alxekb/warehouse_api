# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Warehouse::CurrentTimeSlotQuery do
  subject(:query) { described_class.new }

  let(:cargo_carrier_name) { 'Bogus' }
  let(:started_at) { (DateTime.now + 1.day + 1.hour).to_s }
  let(:ended_at) { (DateTime.now + 1.day + 2.hours).to_s }
  let(:slot_booking) do
    create(:slot_booking, cargo_carrier_name:, started_at:, ended_at:)
  end

  describe '#call' do
    context 'when there is no slot booking' do
      it 'is blank' do
        expect(query.call).to be_blank
      end
    end

    context 'when there is a slot booking' do
      before do
        slot_booking
      end

      it 'returns the slot booking' do
        expect(query.call).to eq([slot_booking])
      end
    end
  end
end
