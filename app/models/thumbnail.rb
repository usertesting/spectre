require 'image_size'
require 'open-uri'

class Thumbnail
  def initialize(asset, key)
    @asset = asset
    @key = key
  end

  def create_thumbnail
    @asset.thumb('300x').encode('jpg', '-quality 90')
  end

  def thumbnail_filename
    Digest::SHA1.hexdigest(@key)
  end

  def thumbnail_path
    File.join("thumbnails", thumbnail_filename)
  end

  def thumbnail_full_path
    File.join(Rails.env, "thumbnails", thumbnail_filename)
  end

  def width
    100
    # get_size.first 
  end

  def height
    200
    # get_size.second
  end

  def url
    unless exists?
      create_thumbnail.store(path: thumbnail_path)
    end

    s3.bucket("ut-screenshots").object(thumbnail_full_path).public_url
  end

  def delete
    s3.bucket("ut-screenshots").object(thumbnail_full_path).delete if exists?
  end

  private

  def exists?
    @exists ||= s3.bucket("ut-screenshots").object(thumbnail_full_path).exists?
  end

  def get_size
    return @size if defined?(@size)

    open(url) do |f|
      @size = ImageSize.new(f).size
    end

    @size
  end

  def s3
    @s3 ||= Aws::S3::Resource.new(region: "us-west-2", access_key_id: ENV["ACCESS_KEY_ID"], secret_access_key: ENV["SECRET_ACCESS_KEY"])
  end
end
