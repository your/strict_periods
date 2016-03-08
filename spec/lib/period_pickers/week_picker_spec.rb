require 'spec_helper'
require 'strict_periods/period_pickers/week_picker'
require 'time'

describe StrictPeriods::PeriodPickers::WeekPicker do

	let(:anchor) { Time.utc(2016,3,7) }
	let(:week_picker) { StrictPeriods::PeriodPickers::WeekPicker.new(anchor: anchor) }

  describe "#new" do
  	context "when a valid anchor date is provided" do
      it "accepts anchor date formatted as '%Y-%m-%d' string" do
        expect(week_picker.anchor).to be_truthy
        expect(week_picker.anchor).to be_an_instance_of Time
        expect(week_picker.anchor).to eq Time.utc(2016,3,7)
        expect(week_picker.instance_variable_get(:@steps)).to eq 0
      end
    end

    context "when no anchor is provided at all" do
    	let(:anchor) { nil }
      it { expect{ week_picker }.to raise_error ArgumentError }
    end

    context "when an invalid anchor is provided" do
      let(:anchor) { "INVALID" }
      it { expect{ week_picker }.to raise_error ArgumentError }
    end

    context "when past_only is not provided" do 
    	it { expect(week_picker.past_only).to eq true }
    end

    context "when past_only is provided" do 
    	let(:week_picker) { StrictPeriods::PeriodPickers::WeekPicker.new(anchor: anchor, past_only: false) }
    	it { expect(week_picker.past_only).to eq false }
    end
  end

  describe "#operands" do
  	let(:number_of_weeks) { 2 }
  	context "when using minus operand" do
  		before do
  			week_picker - number_of_weeks
  		end
  		it { expect(week_picker.anchor).to eq Time.utc(2016,2,22) }
  		it { expect(week_picker.instance_variable_get(:@steps)).to eq -number_of_weeks }

  		context "_offset_anchor should be the same" do
		  	before do
		  		week_picker.send(:_offset_anchor)
		  	end
		  	it { expect(week_picker.instance_variable_get(:@offset)).to eq 60*60*24*(7 - 1)}
		  end
  	end

  	context "when using plus operand" do
  		before do
  			week_picker + number_of_weeks
  		end
  		it { expect(week_picker.anchor).to eq Time.utc(2016,3,21) }
  		it { expect(week_picker.instance_variable_get(:@steps)).to eq number_of_weeks }

  		context "_offset_anchor should be the same" do
		  	before do
		  		week_picker.send(:_offset_anchor)
		  	end
		  	it { expect(week_picker.instance_variable_get(:@offset)).to eq 60*60*24*(7 - 1)}
		  end
  	end
  end
end
