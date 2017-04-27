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
    process resize_to_fit: [1024, 1024]
  end

  def extension_white_list
    %w(jpg jpeg)
  end

   def filename
     "#{secure_token(10)}.#{file.extension}" if original_filename.present?
   end

   protected
   def secure_token(length=16)
     var = :"@#{mounted_as}_secure_token"
     model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
   end
end