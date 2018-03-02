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

  def content_type_whitelist
    /image\//
  end

  def content_type_blacklist
    %w[application/text application/json]
  end

  # Set the filename for versioned files
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def secure_token
    media_original_filenames_var = :"@#{mounted_as}_original_filenames"

    model.instance_variable_set(media_original_filenames_var, {}) unless model.instance_variable_get(media_original_filenames_var)

    unless model.instance_variable_get(media_original_filenames_var).map { |k, _v| k }.include? original_filename.to_sym
      new_value = model.instance_variable_get(media_original_filenames_var).merge("#{original_filename}": SecureRandom.uuid)
      model.instance_variable_set(media_original_filenames_var, new_value)
    end

    model.instance_variable_get(media_original_filenames_var)[original_filename.to_sym]
  end
end
