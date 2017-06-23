require 'dragonfly'
require 'dragonfly/s3_data_store'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "5fc2f8d11fb3d4ad28a4c4e3e353d2ca9e041e14930d48a5c1242613f9cdd2cc"

  url_format "/media/:job/:name"

  datastore :s3,
    access_key_id: ENV['ACCESS_KEY_ID'],
    secret_access_key: ENV['SECRET_ACCESS_KEY'],
    region: 'us-west-2',
    bucket_name: 'ut-screenshots',
    root_path: Rails.env
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
