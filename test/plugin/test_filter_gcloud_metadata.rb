require_relative '../helper'
require 'test/unit'
require 'fluent/test'
require 'fluent/test/driver/filter'
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

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::GcloudMetadataFilter).configure(conf)
  end

  def test_filter_metadata

    input = {'message' => 'foobar'}

    d = create_driver
    VCR.use_cassette('metadata', :allow_unused_http_interactions => false) do
      d.run(default_tag: "test.input") do
        d.feed input
      end
    end
    expected = {'message' => 'foobar', 'gce_project' => 'foobar_project', 'environment' => 'testing'}

    assert_equal expected, d.filtered.map{|e| e.last}.first
  end

  def test_filter_metadata_with_cache

    inputs = [
        {'message' => 'foobar'},
        {'message' => 'foobar2'},
    ]

    d = create_driver
    VCR.use_cassette('metadata', :allow_unused_http_interactions => false) do
      d.run(default_tag: "test.input") do
        inputs.each do |dat|
          d.feed dat
        end
      end
    end
    expected = [
      {'message' => 'foobar', 'gce_project' => 'foobar_project', 'environment' => 'testing'},
      {'message' => 'foobar2', 'gce_project' => 'foobar_project', 'environment' => 'testing'}
    ]

    assert_equal expected, d.filtered.map{|e| e.last}
  end

  def test_filter_return_orignal_record_for_error

    input = {'message' => 'foobar'}

    d = create_driver
    d.run(default_tag: "test.input") do
      d.feed input
    end

    expected = {'message' => 'foobar'}

    assert_equal expected, d.filtered.map{|e| e.last}.first
  end
end
