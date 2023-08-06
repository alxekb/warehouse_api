# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SlotBooking, type: :model do # rubocop:disable Metrics/BlockLength
  subject(:slot_booking) { build(:slot_booking, started_at: DateTime.now, ended_at: DateTime.now) }

  # most of the validations are tested in the validator spec are subject to change
  describe 'validations' do # rubocop:disable Metrics/BlockLength
    context 'when the slot length' do # rubocop:disable Metrics/BlockLength
      describe 'is less than 15 minutes' do # rubocop:disable Metrics/BlockLength
        let(:started_at) { DateTime.now + 25.hours }
        let(:ended_at_less) { started_at + 14.minutes }
        let(:ended_at_eql) { started_at + 15.minutes }
        let(:ended_at_more) { started_at + 16.minutes }
        let(:exactly_45_minutes) { started_at + 45.minutes }

        before do
          slot_booking.started_at = started_at
          slot_booking.ended_at = ended_at_less
        end

        it { is_expected.not_to be_valid }

        describe 'is equal to 15 minutes' do
          before do
            slot_booking.ended_at = ended_at_eql
          end

          it { is_expected.to be_valid }
        end

        context 'when is more than 15 minutes' do
          context 'when 16 minutes' do
            before do
              slot_booking.ended_at = ended_at_more
            end

            it { is_expected.not_to be_valid }
          end

          context 'when 45 minutes' do
            before do
              slot_booking.ended_at = exactly_45_minutes
            end

            it { is_expected.to be_valid }
          end
        end
      end
    end
    context 'when start_time is not present' do
      before { slot_booking.started_at = nil }

      it { is_expected.not_to be_valid }
    end

    context 'when end_time is not present' do
      before { slot_booking.ended_at = nil }

      it { is_expected.not_to be_valid }
    end

    context 'when start_time is after end_time' do
      before do
        slot_booking.started_at = Date.today + 1.day
        slot_booking.ended_at = Date.today
      end

      it { is_expected.not_to be_valid }
    end

    context 'when start_time is before end_time' do
      context 'when start_time is less than 24 hours from now' do
        before do
          slot_booking.started_at = Time.now + 1.hour
          slot_booking.ended_at = Time.now + 1.day
        end

        it { is_expected.not_to be_valid }
      end

      context 'when start_time is more than 24 hours from now' do
        before do
          slot_booking.started_at = DateTime.now + 2.days
          slot_booking.ended_at = DateTime.now + 2.days + 1.hour
        end

        it do
          is_expected.to be_valid
        end
      end
    end

    context 'when start_time is before current time' do
      before { slot_booking.started_at = Date.today - 1.day }

      it { is_expected.not_to be_valid }
    end

    context 'when start_time is after current time' do
      before do
        slot_booking.started_at = DateTime.now + 1.day + 1.hour
      end

      it { is_expected.not_to be_valid }
    end
  end
end
