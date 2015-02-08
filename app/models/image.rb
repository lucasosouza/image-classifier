class Image < ActiveRecord::Base

has_many    :labels
after_save  :classify

  def classify
    if self.labels == []
      self.watson!
    end
  end

  def watson!
    url = URI.parse('https://gateway.watsonplatform.net/visual-recognition-beta/api/v1/tag/recognize')
    File.open(self.file_name) do |jpg|
      req = Net::HTTP::Post::Multipart.new url.path,
        "file" => UploadIO.new(jpg, "image/jpeg", "image.jpg")
      req.basic_auth '4fd248c9-cf8a-4f10-b0ee-0dc50cb55791', 'N281pZdCrGZK'
      res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') do |http|
        http.request(req)
      end
      create_labels(JSON.parse(res.body))
    end
  end

  def create_labels(response)
    rank_counter = 0
    parse_labels(response).each do |label, score|
      rank_counter += 1
      Label.create(category: label, rank: rank_counter, score: score, image_id: self.id)
    end
  end

  def parse_labels(response)
    labels_data = {}
    response["images"][0]["labels"].each do |label|
      labels_data[label["label_name"]] = label["label_score"]
    end
    labels_data
  end

end
