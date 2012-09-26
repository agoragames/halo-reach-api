require 'spec_helper'

describe Halo::Reach::Util do
  it 'should be able to parse a correctly formatted timestamp' do
    utc_time = Time.now.utc
    milliseconds_since_epoch = utc_time.to_i * 1000
    timezone = '0500'
    api_timestamp = build_timestamp(milliseconds_since_epoch, timezone)

    parsed_time, parsed_timezone = Halo::Reach::Util::parse_timestamp(api_timestamp)
    utc_time.to_s.should == parsed_time.to_s
    timezone.should == parsed_timezone
  end

  it 'should raise an ArgumentError on trying to parse a malformed timestamp' do
    invalid_timestamps = [
      nil, # nothing at all
      '', # empty timestamp
      '/Date(/', # generally malformed timestamp
      '/Date()/', # malformed timestamp missing actual data
      build_timestamp('',''), # missing both millisends and timezone
      build_timestamp('','0700'), # missing millisends
      build_timestamp(Time.now.utc.to_i * 1000, ''), # missing timezone
      build_timestamp('abc1041', '04jhg'), # prepended/trailing garbage
      build_timestamp('43gi', 'tb01'), # trailing/prepended garbage
      build_timestamp('ed456mb', 'mvn029hgd'), # surrounded by garbage
      build_timestamp('asd;kf', 'sdfoih') # omg pure garbage
    ]

    invalid_timestamps.each do |invalid_timestamp|
      expect { Halo::Reach::Util::parse_timestamp(invalid_timestamp) }.to raise_error(ArgumentError)
    end
  end

  private

  def build_timestamp(milliseconds_since_epoch, timezone)
    "/Date(#{milliseconds_since_epoch.to_s}-#{timezone.to_s})/"
  end
end