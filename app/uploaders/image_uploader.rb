class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  def move_to_cache
    true
  end

  def move_to_store
    true
  end
  storage :file
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  version :ineditor do
    process resize_to_fit: [896, 896]
  end
  version :thumb, from_version: :ineditor do
    process resize_to_fit: [108, 108]
  end

  def extension_white_list
    %w[jpg jpeg]
  end

  def content_type_blacklist
    %w[application/text application/json]
  end
end
