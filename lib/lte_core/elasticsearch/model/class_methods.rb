require 'elasticsearch'

module LteCore
  module Elasticsearch
    class Model
      module ClassMethods
        attr_reader :client, :index

        def connect(client_config)
          @client = ::Elasticsearch::Client.new(url: client_config[:url])
          @index = client_config[:index]
        end

        def index_exists?
          client.indices.exists? index: index
        end

        def create_index
          client.indices.create(index: index) unless index_exists?
        end
      end
    end
  end
end
