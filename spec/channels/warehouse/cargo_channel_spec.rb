# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Warehouse::CargoChannel, type: :channel do # rubocop:disable Metrics/BlockLength
  before do
    stub_connection
    subscribe
  end

  describe 'subscribed' do
    it 'successfully subscribes' do
      aggregate_failures do
        expect(subscription).to be_confirmed
        expect(subscription).to have_stream_from(
          Warehouse::CargoChannel::TARGET_CHANNEL
        )
      end
    end
  end

  describe '#cargo' do
    let(:date) { DateTime.now + 1.day + 1.hour }
    let(:slot_booking) do
      build(:slot_booking, started_at: date, ended_at: date + 15.minutes)
    end

    before do
      slot_booking.save
    end

    it 'calls query' do
      allow(Warehouse::CurrentTimeSlotQuery).to receive(:call)

      perform :cargo

      expect(Warehouse::CurrentTimeSlotQuery).to have_received(:call)
    end
  end

  describe 'broadcasting' do
    it 'broadcasts a message to the cargo_channel' do
      expect do
        perform :cargo
      end.to have_broadcasted_to(Warehouse::CargoChannel::TARGET_CHANNEL)
    end
  end
end
