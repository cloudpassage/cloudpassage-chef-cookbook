# encoding: utf-8
require 'aws-sdk'
require 'json'
require 'stringio'

class S3
  class << self
    def list_buckets
      S3.client.list_buckets
    end

    def list_objects(name, delimiter = nil)
      S3.client.list_objects(bucket: name, delimiter: delimiter)
    end

    def show_object_contents(bucket_name, obj_key)
      resp = S3.client.get_object(bucket: bucket_name, key: obj_key)
      StringIO.new(resp.body.read).string
    end

    protected

    def client
      @client ||= make_client
    end

    def make_client
      Aws::S3::Client.new(
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region: ENV['AWS_REGION']
      )
    end
  end
end
