require 'spec_helper'
require 'strict_periods'
require 'time'

describe StrictPeriod do

  let(:now) { Time.now.utc }
  let(:anchor) { nil }
  let(:strict_period) { described_class.new(anchor: anchor) }

  describe "#new" do
    context "when a valid anchor date is provided" do
      let(:anchor) { Time.utc(2016,3,7).strftime('%Y-%m-%d') }

      it "accepts anchor date formatted as '%Y-%m-%d' string" do
        expect(strict_period.anchor).to be_truthy
        expect(strict_period.anchor).to be_an_instance_of Time
        expect(strict_period.anchor.strftime('%Y-%m-%d')).to eq Time.utc(2016,3,7).strftime('%Y-%m-%d')
      end
    end

    context "when no anchor is provided at all" do
      it "set the anchor date to the current day" do
        expect(strict_period.anchor).to be_truthy
        expect(strict_period.anchor).to be_an_instance_of Time
        expect(strict_period.anchor.strftime('%Y-%m-%d')).to eq Time.utc(now.year, now.month, now.day).strftime('%Y-%m-%d')
      end
    end

    context "when an invalid anchor is provided" do
      let(:anchor) { "INVALID" }

      it { expect{ strict_period }.to raise_error ArgumentError }
    end

    context "when past_only is not provided" do 
      it { expect(strict_period.past_only).to eq true }
    end

    context "when past_only is provided" do 
      let(:strict_period) { described_class.new(anchor: anchor, past_only: false) }
      it { expect(strict_period.past_only).to eq false }
    end
  end

  describe "#_anchor_at" do
    context "when no anchor is provided" do
      anchor = described_class.new.send(:_anchor_at, nil)

      it { expect(anchor).to be_truthy }
      it { expect(anchor).to be_an_instance_of Time }
      it { expect(anchor.strftime('%Y-%m-%d')).to eq now.strftime('%Y-%m-%d') }
    end
  end

  describe "#next_week" do
    context "when the actual next week is in the future" do
      it { expect(strict_period.next_week).to eq nil }
    end

    context "when the actual next week is in the past" do
      let(:anchor) { Time.utc(2015,3,7).strftime('%Y-%m-%d') }

      it { expect(strict_period.next_week).to eq ["2015-03-09", "2015-03-15"] }
      it { expect(Time.parse(strict_period.next_week[0]).monday?).to eq true }
      it { expect(Time.parse(strict_period.next_week[1]).sunday?).to eq true }
    end
  end

  describe "#previous_week" do
    context "when the actual previous week is in the future" do
      let(:anchor) { Time.utc(2099,3,7).strftime('%Y-%m-%d') }

      it { expect(strict_period.previous_week).to eq nil }
    end

    context "when the actual previous week is in the past" do
      let(:anchor) { Time.utc(2015,3,7).strftime('%Y-%m-%d') }

      it { expect(strict_period.previous_week).to eq ["2015-02-23", "2015-03-01"] }
      it { expect(Time.parse(strict_period.previous_week[0]).monday?).to eq true }
      it { expect(Time.parse(strict_period.previous_week[1]).sunday?).to eq true }
    end
  end

  describe "#previous_weeks" do
    let(:anchor) { Time.utc(2015,3,7).strftime('%Y-%m-%d') }
    let(:number_of_weeks) { 2 }

    context "when number_of_weeks value is not provided" do
      it { expect(strict_period.previous_weeks).to be_kind_of(Array) }
      it { expect(strict_period.previous_weeks).to eq [["2015-02-23", "2015-03-01"]] }
      it { expect(Time.parse(strict_period.previous_weeks[0][0]).monday?).to eq true }
      it { expect(Time.parse(strict_period.previous_weeks[0][1]).sunday?).to eq true }
    end

    context "when number_of_weeks value is provided" do
      it { expect(strict_period.previous_weeks).to be_kind_of(Array) }
      it { expect(strict_period.previous_weeks(number_of_weeks)).to eq [["2015-02-16", "2015-02-22"],["2015-02-23", "2015-03-01"]] }
      it { expect(Time.parse(strict_period.previous_weeks(number_of_weeks)[0][0]).monday?).to eq true }
      it { expect(Time.parse(strict_period.previous_weeks(number_of_weeks)[0][1]).sunday?).to eq true }
      it { expect(Time.parse(strict_period.previous_weeks(number_of_weeks)[1][0]).monday?).to eq true }
      it { expect(Time.parse(strict_period.previous_weeks(number_of_weeks)[1][1]).sunday?).to eq true }
    end
  end

  describe "#next_weeks" do
    context "when next weeks are in the future" do
      it { expect(strict_period.next_weeks).to be_kind_of(Array) }
      it { expect(strict_period.next_weeks).to eq [] }
    end

    context "when next weeks are in the past" do
      let(:anchor) { Time.utc(2015,3,7).strftime('%Y-%m-%d') }
      let(:number_of_weeks) { 2 }

      context "when number_of_weeks value is not provided" do
        it { expect(strict_period.next_weeks).to be_kind_of(Array) }
        it { expect(strict_period.next_weeks).to eq [["2015-03-09", "2015-03-15"]] }
        it { expect(Time.parse(strict_period.next_weeks[0][0]).monday?).to eq true }
        it { expect(Time.parse(strict_period.next_weeks[0][1]).sunday?).to eq true }
      end

      context "when number_of_weeks value is provided" do
        it { expect(strict_period.next_weeks(number_of_weeks)).to be_kind_of(Array) }
        it { expect(strict_period.next_weeks(number_of_weeks)).to eq [["2015-03-09", "2015-03-15"],["2015-03-16", "2015-03-22"]] }
        it { expect(Time.parse(strict_period.next_weeks(number_of_weeks)[0][0]).monday?).to eq true }
        it { expect(Time.parse(strict_period.next_weeks(number_of_weeks)[0][1]).sunday?).to eq true }
        it { expect(Time.parse(strict_period.next_weeks(number_of_weeks)[1][0]).monday?).to eq true }
        it { expect(Time.parse(strict_period.next_weeks(number_of_weeks)[1][1]).sunday?).to eq true }
      end
    end
  end
end
