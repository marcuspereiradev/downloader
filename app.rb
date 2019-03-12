require 'sinatra'
require './downloader'

get '/watch' do
  video_id = params['v']
  formats = fetch_yt(video_id)
  erb :index, locals: {video_id: video_id, formats: formats}
end