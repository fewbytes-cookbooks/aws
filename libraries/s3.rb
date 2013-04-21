
begin
  require 'right_aws'
rescue LoadError
  Chef::Log.warn("Missing gem 'right_aws'")
end

module Opscode
  module Aws
    module S3
      def s3
        ::Chef::Log.info("Getting S3 connection with access_key_id: #{new_resource.aws_access_key_id}" )
        @@s3 ||= ::RightAws::S3.new(new_resource.aws_access_key_id, new_resource.aws_secret_access_key, { :logger => Chef::Log })
      end
      def key(bucket_name, key_name)
        # to work around a RightAws bug with IAM permissions, use Bucket.new instead of s3.bucket
        bucket = ::RightAws::S3::Bucket.new(s3, bucket_name)
        bucket.key(key_name)
      end
    end
  end
end

