require 'net/http'
require 'nokogiri'
require "execjs"

def fetch_yt(video_id)
  uri = URI("https://www.youtube.com/watch?v=#{video_id}")
  doc = Nokogiri::HTML(Net::HTTP.get(uri))

  script_content = "window = {}; " + doc.css('#player script')[1].content

  execjs = ExecJS.compile(script_content)

  parsed_response = JSON.parse(execjs.eval('ytplayer.config.args.player_response'))

  filter_mp4_format = parsed_response["streamingData"]["adaptiveFormats"].select do |data|
    data['mimeType'].match(/mp4/)
  end

  response = filter_mp4_format.map do |format|
    {
      resolution: format['qualityLabel'],
      url_download: format['url']
    }
  end
  response
end
