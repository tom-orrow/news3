# encoding: utf-8

class TitlepicUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  after :store, :unlink_original

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    "articles/#{version_name}/missing_titlepic.jpg"
  end

  version :thumb do
    process resize_to_fill: [390, 250]
  end

  version :medium do
    process resize_to_fill: [806, 400]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  private

  def unlink_original(file)
    File.delete path if version_name.blank?
  end
end
