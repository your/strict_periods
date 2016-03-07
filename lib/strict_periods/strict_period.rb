module StrictPeriods
  class StrictPeriod
    attr_accessor :anchor
    attr_accessor :past_only

    def initialize(anchor: nil, past_only: true)
      @anchor    = _anchor_at(anchor)
      @past_only = past_only

      _init_week_picker
    end

    def anchor=(anchor)
      @anchor = _anchor_at(anchor)

      _update_week_picker
    end

    def past_only=(past_only)
      @past_only = past_only

      _update_week_picker
    end

    %w(previous next).each do |time_place|
      define_method("#{time_place}_week") do
        raise WeekPickerError if @week_picker.nil?

        week = if time_place == 'previous'
          @week_picker.backwards!
        elsif time_place == 'next'
          @week_picker.forward!
        end

        @week_picker.reset!
        return week
      end
    end

    def previous_weeks(number_of_weeks = 1)
      raise WeekPickerError if @week_picker.nil?

      weeks = (0..number_of_weeks-1).map.with_index do |i|
        @week_picker.backwards!
      end.compact

      @week_picker.reset!
      return weeks.reverse
    end

    def next_weeks(number_of_weeks = 1)
      raise WeekPickerError if @week_picker.nil?

      weeks = (0..number_of_weeks-1).map.with_index do |i|
        @week_picker.forward!
      end.compact

      @week_picker.reset!
      return weeks
    end

    %w(previous next).each do |time_place|
      define_method("grouped_#{time_place}_weeks") do |number_of_weeks|
        raise WeekPickerError if @week_picker.nil?

        weeks = if time_place == 'previous'
          previous_weeks(number_of_weeks)
        elsif time_place == 'next'
          next_weeks(number_of_weeks)
        end

        [weeks[0][0], weeks[-1][-1]] unless weeks.nil? || weeks.size == 0
      end
    end

    private

    def _anchor_at(anchor)
      if anchor.nil?
        Time.now.utc
      else
        raise ArgumentError, "Invalid date format" unless anchor.include?('-')

        date = anchor.split('-')
        raise ArgumentError, "Invalid date format" unless date.size == 3

        Time.utc(date[0], date[1], date[2], 0, 0, 0)
      end
    end

    def _init_week_picker
      raise AnchorError if @anchor.nil?

      @week_picker ||= StrictPeriods::PeriodPickers::WeekPicker.new(anchor: @anchor, past_only: @past_only)
    end

    def _update_week_picker
      @week_picker.anchor    = @anchor unless @anchor.nil?
      @week_picker.past_only = @past_only

      _init_week_picker
    end
  end
end
