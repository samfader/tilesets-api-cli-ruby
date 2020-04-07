require 'tty-prompt'
require 'dotenv/load'
require 'http'

class TilesetSource
  @prompt = TTY::Prompt.new(enable_color: true)
  def self.create
    puts "uhhh"
    # /Users/samfader/mapbox/tilesets-api-ruby/nyc_pois.geojson.ld
    result = @prompt.collect do
      key(:file).ask('Enter the full path (i.e. /Users/name/folder/file.geojson.ld) to your line-delimited GeoJSON file:')
      key(:source_id).ask('give your source an id:', help: 'max 32 characters, only - and _ for special characters')
    end
    ## Create source https://docs.mapbox.com/api/maps/#create-a-tileset-source
    ## file with variables. also put post on new line, just bundle exec irb doesn't like it
    puts "Working..."

    createSource = HTTP[:accept => "multipart/form-data"].post("#{ENV['BASE_URL']}/sources/#{ENV['USERNAME']}/#{result[:source_id]}", :params => {:access_token => ENV['ACCESS_TOKEN']} ,:form => {
        :file   => HTTP::FormData::File.new(result[:file])
      })

    if createSource.code != 200
      puts "Uh oh! You're hitting a #{createSource.status} error. Look into the docs, then try running this script again. Here's the full response: \n #{createSource.body.to_s}"
    else
      puts "Success! Here are the details you seek: \n 
      Source id is #{createSource.parse["id"]} \n
      Files within source: #{createSource.parse["files"]} \n
      The total size of your source is: #{createSource.parse["source_size"] / 1000000}MB \n
      The total size of the file you uploaded is: #{createSource.parse["file_size"] / 1000000}MB"
    end

    Index.restart
  end

  def self.retrieve
    result = @prompt.collect do
      key(:source_id).ask('Source ID of the tileset source to retrieve:')
    end

    puts "Working..."

    retrieveSource = HTTP.get("#{ENV['BASE_URL']}/sources/#{ENV['USERNAME']}/#{result[:source_id]}", :params => {:access_token => ENV['ACCESS_TOKEN']})
    if retrieveSource.code != 200
      puts "Uh oh! You're hitting a #{retrieveSource.status} error. Look into the docs, then try running this script again. Here's the full response: \n #{retrieveSource.body.to_s}"
    else
      puts "Success! Here are the details you seek: \n #{retrieveSource.body.to_s}" 
    end

    Index.restart
  end

  def self.list
    puts "Working..."

    listSources = HTTP.get("#{ENV['BASE_URL']}/sources/#{ENV['USERNAME']}", :params => {:access_token => ENV['ACCESS_TOKEN']})
    if listSources.code != 200
      puts "Uh oh! You're hitting a #{listSources.status} error. Look into the docs, then try running this script again. Here's the full response: \n #{listSources.body.to_s}"
    else
      puts "Success! Here are the details you seek: \n #{listSources.body.to_s}" 
    end

    Index.restart
  end

  def self.delete
    puts "Working..."

    result = @prompt.collect do
      key(:source_id).ask('Source ID of the tileset source to delete:')
    end

    puts "Working..."

    deleteSource = HTTP.delete("#{ENV['BASE_URL']}/sources/#{ENV['USERNAME']}/#{result[:source_id]}", :params => {:access_token => ENV['ACCESS_TOKEN']})
    ## Tilesets API returns 204 when successfully deleted
    if deleteSource.code != 204
      puts "Uh oh! You're hitting a #{deleteSource.status} error. Look into the docs, then try running this script again. Here's the full response: \n #{deleteSource.body.to_s}"
    else
      puts "Success! Here are the details you seek: \n #{deleteSource.body.to_s}" 
    end

    Index.restart
  end
end