class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  include CarrierWave::ImageOptimizer
  process optimize: [{ quality: 90 }]
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :ineditor do
    process resize_to_limit: [960, nil]
  end

  def extension_white_list
    %w(jpg jpeg)
  end

end