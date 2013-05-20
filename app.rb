require 'open-uri'

class SpiritualApp < Sinatra::Base
  configure :development do
    Bundler.require :development
    register Sinatra::Reloader   end
  get "/" do
    send_file File.join('index.html')
  end

  get "/process" do
    url = params[:url]
    unless url
      halt 400, 'url required'
    end

    content = open(url).read

    source_image = Magick::Image.from_blob(content).first

    radius = [source_image.columns, source_image.rows, 50.0].min
    sigma = radius / 5
    dest_image = source_image.blur_image radius, sigma
    dest_image.format = 'JPEG'

    content_type 'image/jpeg'

    dest_image.to_blob
  end

end
