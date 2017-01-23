class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick
  # include CarrierWave::ImageOptimizer
  # process optimize: [{ quality: 100 }]
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :ineditor do
    process resize_to_limit: [500, nil]
  end

  def extension_white_list
    %w(jpg jpeg)
  end

end