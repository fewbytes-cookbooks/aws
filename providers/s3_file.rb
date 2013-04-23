include ::Opscode::Aws::S3

def whyrun_supported?
  true
end

use_inline_resources 

action :create do
  Chef::Log.debug "Fetching key object for #{new_resource.bucket}/#{new_resource.key}"
  s3_key = key(new_resource.bucket, new_resource.key)
  unless s3_key.exists?
    raise Chef::Exceptions::FileNotFound,
      "S3 key %s does not exist in bucket %s" % [new_resource.key, new_resource.bucket]
  end
  begin
    md5 = ::Digest::MD5.file(new_resource.path).hexdigest
  rescue Errno::ENOENT # file not found
    md5 = nil
  end
  unless s3_key.e_tag and md5 == s3_key.e_tag.delete('"')
    Chef::Log.info "MD5 of #{new_resource.path} differs from Etag of S3 key, downloading."
    Chef::Log.debug "#{new_resource.path} MD5: #{md5}, ETag: #{s3_key.e_tag.delete('"')}"
    f_owner = new_resource.owner
    f_group = new_resource.group
    f_mode = new_resource.mode
    remote_file new_resource.path do
      source s3.interface.get_link(s3_key.bucket, s3_key.name, (Time.now + 300).strftime('%s'))
      owner f_owner if f_owner
      group f_group if f_group
      mode f_mode if f_mode
      backup new_resource.backup
      action :create
    end
  else
    Chef::Log.info "MD5 of #{new_resource.path} is equal to Etag, skipping download"
  end
end

action :create_if_missing do
  action_create unless ::File.exists? new_resource.path
end
