# index_controller.rb
get '/' do
  if Label.all != []
    @labels = count_ocurrences_per_label
  end
  erb :index
end

get '/photos' do
  get_labels_from_watson(params[:photos])
  @labels = count_ocurrences_per_label
  erb :index
end

get '/run' do
  get_labels_from_watson
  @labels = count_ocurrences_per_label
  erb :index
end

post '/categories' do
  @categories = params[:categories]
  assign(@categories)
  @categories << "Unassigned"
  erb :photos
end