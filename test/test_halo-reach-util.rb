require 'helper'

class TestHaloReachUtil < Test::Unit::TestCase

  def test_can_parse_correctly_formatted_timestamp
    utc_time = Time.now.utc
    milliseconds_since_epoch = utc_time.to_i * 1000
    timezone = '0500'
    api_timestamp = build_timestamp(milliseconds_since_epoch, timezone)

    parsed_time, parsed_timezone = Halo::Reach::Util::parse_timestamp(api_timestamp)
    assert_equal utc_time.to_s, parsed_time.to_s
    assert_equal timezone, parsed_timezone
  end

  def test_raise_invalid_timestamp_argument_error_on_malformed_timestamp
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
      assert_raises(ArgumentError) do
        Halo::Reach::Util::parse_timestamp(invalid_timestamp)
      end
    end
  end

  def build_timestamp(milliseconds_since_epoch, timezone)
    "/Date(#{milliseconds_since_epoch.to_s}-#{timezone.to_s})/"
  end
end
