namespace :resize do
  desc 'RESIZE'
  task recreate: :environment do
    Partner.all.each do |partner|
      partner.attachment.recreate_versions!
    end
    Gallery.all.each do |gallery|
      gallery.images.each(&:recreate_versions!)
    end
  end
end
