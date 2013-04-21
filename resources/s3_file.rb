attribute :path,                  :kind_of => String, :name_attribute => true
attribute :bucket,                :kind_of => String, :required => true
attribute :key,                   :kind_of => String, :required => true
attribute :aws_access_key_id,     :kind_of => String
attribute :aws_secret_access_key, :kind_of => String
attribute :owner,                 :regex => [ /^([a-z]|[A-Z]|[0-9]|_|-)+$/, /^\d+$/ ]
attribute :group,                 :regex => [ /^([a-z]|[A-Z]|[0-9]|_|-)+$/, /^\d+$/ ]
attribute :mode,                  :regex => /^0?\d{3,4}$/
attribute :backup,                :kind_of => [ Integer, FalseClass ], :default => 5

actions :create, :create_if_missing
