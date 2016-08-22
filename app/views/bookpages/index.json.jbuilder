json.array!(@bookpages) do |bookpage|
  json.extract! bookpage, :id, :pagenum
  json.url bookpage_url(bookpage, format: :json)
end
