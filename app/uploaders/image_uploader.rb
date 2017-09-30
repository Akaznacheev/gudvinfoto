class ImageUploader < CarrierWave::Uploader::Base
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  # include CarrierWave::ImageOptimizer
  # process optimize: [{ quality: 90 }]
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

  # def filename
  #   "#{model.id}_"+rand(36**8).to_s(36)+'.jpg' if original_filename
  # end
end
