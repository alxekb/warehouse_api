# frozen_string_literal: true

module Warehouse
  # =class Warehouse::SlotBookingValidator
  #
  # Warehouse::SlotBookingValidator validates the slot booking in the SlotBooking model
  class SlotBookingValidator < BaseValidator
    # Maximum length of the carrier name
    MAXIMUM_LENGTH = 255
    # Minimum length of the carrier name
    MINIMUM_LENGTH = 3
    # validate the start and end time of the slot booking
    # validate carrier name

    # @param [SlotBooking] object
    # @return [void]
    def validate(object)
      presence_validation(object)

      return if object.errors.any?

      carrier_name_validation(object)

      started_at_validation(object)
      ended_at_validation(object)

      alignment_validation(object)
      overlap_validation(object)
    end

    private

    # rubocop:disable Style/GuardClause
    # rubocop:disable Style/IfUnlessModifier
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def presence_validation(object)
      if object.started_at.blank?
        object.errors.add(:started_at, 'start of the slot cannot be blank')
      end

      if object.ended_at.blank?
        object.errors.add(:ended_at, 'end of the slot cannot be blank')
      end

      if object.cargo_carrier_name.blank?
        object.errors.add(:cargo_carrier_name, 'cargo carrier name cannot be blank')
      end
    end

    def started_at_validation(object)
      unless object.started_at
        object.errors.add(:started_at, 'Start time must be present')
      end

      if object.started_at >= object.ended_at
        object.errors.add(:started_at, 'Start time must be before end time')
      end

      if object.started_at < DateTime.now
        object.errors.add(:started_at, 'Start time must be in the future')
      end

      # probably not needed but it could be useful to have a time difference between start time and current time
      # due to facility processes and its workers availability
      if object.started_at < DateTime.now + 1.day
        object.errors.add(:started_at, 'Start time must be at least 24 hours from now')
      end
    end

    def ended_at_validation(object)
      unless object.ended_at
        object.errors.add(:ended_at, 'End time must be present')
      end

      if object.ended_at < DateTime.now
        object.errors.add(:ended_at, 'End time must be in the future')
      end
    end

    def carrier_name_validation(object)
      unless object.cargo_carrier_name
        object.errors.add(:ended_at, 'Carrier name must be present')
      end

      if object.cargo_carrier_name.length > MAXIMUM_LENGTH
        object.errors.add :ended_at, <<~MSG
          Carrier name must be less than #{MAXIMUM_LENGTH} characters
        MSG
      end

      if object.cargo_carrier_name.length < MINIMUM_LENGTH
        object.errors.add :ended_at, <<~MSG
          Carrier name must be at least #{MINIMUM_LENGTH} characters
        MSG
      end
    end

    def time_difference(object)
      (object.ended_at - object.started_at).to_i
    end

    def alignment_validation(object)
      if time_difference(object) % 900 != 0
        object.errors.add(:ended_at, 'Start and end time must be aligned to 15-minute increments')
      end
    end

    def overlap_validation(object)
      if Warehouse::SlotBooking
         .where(started_at: object.started_at...object.ended_at)
         .or(Warehouse::SlotBooking
          .where(ended_at: object.started_at...object.ended_at))
         .exists?
        object.errors.add(:ended_at, 'Slot booking overlaps with another slot booking')
      end
    end
    # rubocop:enable Style/GuardClause
    # rubocop:enable Style/IfUnlessModifier
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
  end
end
