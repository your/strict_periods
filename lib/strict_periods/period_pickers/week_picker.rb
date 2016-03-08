module StrictPeriods
  module PeriodPickers
    class WeekPicker
      attr_accessor :anchor
      attr_accessor :past_only

      SECS_IN_A_DAY  = 60*60*24
      SECS_IN_A_WEEK = SECS_IN_A_DAY*7

      def initialize(anchor: nil, past_only: true)
        @steps     = 0
        @anchor    = anchor
        @past_only = past_only
        raise ArgumentError if @anchor.nil? || !@anchor.is_a?(Time)

        _offset_anchor
      end

      def anchor=(anchor)
        @anchor = anchor

        _offset_anchor
      end

      def -(number_of_weeks)
        @anchor -= number_of_weeks * SECS_IN_A_WEEK
        @steps -= number_of_weeks

        _offset_anchor
      end

      def +(number_of_weeks)
        @anchor += number_of_weeks * SECS_IN_A_WEEK
        @steps += number_of_weeks

        _offset_anchor
      end

      def reset!
        _reset_steps
        _reset_offset
      end

      %w(backwards forward).each do |direction|
        define_method("#{direction}!") do
          raise OffsetInitError if @offset.nil?

          if direction == 'backwards'
            self - 1
          elsif direction == 'forward'
            self + 1
          end

          sunday = @anchor + @offset
          monday = @anchor + @offset - (SECS_IN_A_WEEK - SECS_IN_A_DAY)

          if @past_only && (sunday > Time.now.utc || monday > Time.now.utc)
            return # Discarded week in the future (not ended/started yet)
          end

          raise OffsetError unless sunday.sunday? && monday.monday?

          return [monday.strftime('%Y-%m-%d'), sunday.strftime('%Y-%m-%d')]
        end
      end

      private

      def _offset_anchor
        day_of_the_week = @anchor.strftime('%u').to_i # (Monday is 1, 1..7)
        @offset = SECS_IN_A_WEEK - day_of_the_week * SECS_IN_A_DAY
      end

      def _reset_steps
        if @steps < 0
          self + @steps.abs
        elsif @steps > 0
          self - @steps.abs
        end
        @steps = 0
      end

      def _reset_offset
        _offset_anchor
      end
    end
  end
end
