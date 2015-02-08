# index_helper.rb
helpers do

  def get_labels_from_watson_custom(photos)
    limit = 30 #temp
    counter = 0 #temp
    photos.each do |image|
      Image.create(file_name: image, address: File.dirname(image)).labels
      counter += 1 #temp
      break if counter > limit #temp
    end
  end


  def get_labels_from_watson
    limit = 10 #temp
    counter = 0 #temp
    Dir.glob("photos/**/*.jpg") do |image|
      Image.create(file_name: image, address: File.dirname(image)).labels
      counter += 1 #temp
      break if counter > limit #temp
    end
  end

  def count_ocurrences_per_label
    labels_count = {}
    Label.pluck(:category).uniq.each do |cat|
      labels_count[cat] = Label.where(category: cat).count
    end
    labels_count.sort_by { |label, count| count}.reverse!
  end

  def assign(categories)
    Image.all.each do |image|
      image.labels.sort_by {|img| img.rank }.each do |label|
        if categories.include?(label.category)
          image.category = label.category
          image.save
        end
      end
      unless image.category
        image.category = "Unassigned"
        image.save
      end
    end
  end

  def images_by(category)
    Image.where(category: category)
  end

end