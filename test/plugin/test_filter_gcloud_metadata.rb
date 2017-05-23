require_relative '../helper'
require 'test/unit'
require 'fluent/test'
require 'fluent/plugin/filter_gcloud_metadata'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'test/cassettes'
  config.hook_into :webmock
end


class TestGcloudMetadataFilter < Test::Unit::TestCase

  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
      <metadata>
        gce_project project/project-id
        environment instance/attributes/cluster-name
      </metadata>
    ]

  def create_driver(conf = CONFIG, tag='test.input')
    Fluent::Test::FilterTestDriver.new(Fluent::GcloudMetadataFilter, tag).configure(conf)
  end

  def test_filter_metadata

    input = {'message' => 'foobar'}

    d = create_driver
    VCR.use_cassette('metadata', :allow_unused_http_interactions => false) do
      d.run do
        d.filter input
      end
    end
    expected = {'message' => 'foobar', 'gce_project' => 'foobar_project', 'environment' => 'testing'}

    assert_equal expected, d.filtered_as_array[0][2]
  end

  def test_filter_metadata_with_cache

    inputs = [
        {'message' => 'foobar'},
        {'message' => 'foobar2'},
    ]

    d = create_driver
    VCR.use_cassette('metadata', :allow_unused_http_interactions => false) do
      d.run do
        inputs.each do |dat|
          d.filter dat
        end
      end
    end
    expected = {'message' => 'foobar2', 'gce_project' => 'foobar_project', 'environment' => 'testing'}

    assert_equal expected, d.filtered_as_array[1][2]
  end

  def test_filter_return_orignal_record_for_error

    input = {'message' => 'foobar'}

    d = create_driver
    d.run do
      d.filter input
    end

    expected = {'message' => 'foobar'}

    assert_equal expected, d.filtered_as_array[0][2]
  end
end