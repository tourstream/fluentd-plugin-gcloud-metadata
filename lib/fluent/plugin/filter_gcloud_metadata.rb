require 'fluent/filter'
require 'net/http'
require 'uri'

module Fluent

  class GcloudMetadataFilter <  Fluent::Filter
    class ConnectionFailure < StandardError; end
    Fluent::Plugin.register_filter('gcloud_metadata', self)

    def configure(conf)
      super
      @map = {}
      # <record></record> directive
      conf.elements.select { |element| element.name == 'metadata' }.each do |element|
        element.each_pair do |k, v|
          element.has_key?(k) # to suppress unread configuration warning
          @map[k] = v
        end
      end
    end

    def filter(tag, time, record)
      @map.each do |recordName, pathSegment|

        begin
          uri = URI.parse("http://metadata.google.internal/computeMetadata/v1/#{pathSegment}")
          request = Net::HTTP::Get.new(uri)
          request["Metadata-Flavor"] = "Google"

          req_options = {
              use_ssl: uri.scheme == "https",
          }

          response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
          end

          record[recordName] = response.body
        rescue => e
          log.warn "failed to get metadata for #{recordName} from #{pathSegment}. ", error: e
        end
      end

      record
    end

  end
end