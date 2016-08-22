json.array!(@phgalleries) do |phgallery|
  json.extract! phgallery, :id
  json.url phgallery_url(phgallery, format: :json)
end
