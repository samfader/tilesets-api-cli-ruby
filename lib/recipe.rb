require 'tty-prompt'
require 'dotenv/load'
require 'http'

class Recipe
  @prompt = TTY::Prompt.new(enable_color: true)

  def self.validate
    result = @prompt.collect do
      key(:recipe).ask('Enter the full path (i.e. /Users/name/folder/recipe.json) to your recipe:')
    end
    ## Create source https://docs.mapbox.com/api/maps/#create-a-tileset-source
    ## file with variables. also put post on new line, just bundle exec irb doesn't like it
    puts "Working..."

    validateRecipe = HTTP[:accept => "application/json"].put("#{ENV['BASE_URL']}/validateRecipe}", :params => {:access_token => ENV['ACCESS_TOKEN']} ,:form => {
        :file   => HTTP::FormData::File.new(result[:recipe])
      })

    if validateRecipe.code != 200
      puts "Uh oh! You're hitting a #{validateRecipe.status} error. Look into the docs, then try running this script again. Here's the full response: \n #{validateRecipe.body.to_s}"
    else
      puts "Success! Here are the details you seek: \n #{validateRecipe.body.to_s}"
    end
    
    Index.restart
  end

  def self.update
    result = @prompt.collect do
      key(:tileset_id).ask('Enter the ID for the tileset whose recipe you want to update:', help: 'The ID is composed of your username followed by a period and the tileset\'s unique name')
      key(:recipe).ask('Enter the full path (i.e. /Users/name/folder/recipe.json) to your new recipe:')
    end

    puts "Working..."

    updateRecipe = HTTP[:accept => "application/json"].patch("#{ENV['BASE_URL']}/#{result[:tileset_id]}/recipe", :params => {:access_token => ENV['ACCESS_TOKEN']} ,:form => {
        :file   => HTTP::FormData::File.new(result[:recipe])
      })

    if updateRecipe.code != 200
      puts "Uh oh! You're hitting a #{updateRecipe.status} error. Look into the docs, then try running this script again. Here's the full response: \n #{updateRecipe.body.to_s}"
    else
      puts "Success! Here are the details you seek: \n #{updateRecipe.body.to_s}"
    end

    Index.restart
  end

  def self.retrieve
    result = @prompt.collect do
      key(:tileset_id).ask('Enter the ID for the tileset whose recipe you want to retrieve:', help: 'The ID is composed of your username followed by a period and the tileset\'s unique name')
    end

    puts "Working..."

    retrieveRecipe = HTTP.get("#{ENV['BASE_URL']}/#{result[:tileset_id]}/recipe", :params => {:access_token => ENV['ACCESS_TOKEN']})
    if retrieveRecipe.code != 200
      puts "Uh oh! You're hitting a #{retrieveRecipe.status} error. Look into the docs, then try running this script again. Here's the full response: \n #{retrieveRecipe.body.to_s}"
    else
      puts "Success! Here are the details you seek: \n #{retrieveRecipe.body.to_s}" 
    end

    Index.restart
  end
end