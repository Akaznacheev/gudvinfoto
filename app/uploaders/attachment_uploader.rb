class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::ImageOptimizer
  process optimize: [{ quality: 100 }]
  storage :file
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  version :small do
    process resize_to_fit: [144, 144]
  end
end
