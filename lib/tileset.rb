require 'tty-prompt'
require 'dotenv/load'
require 'http'

class Tileset
  @prompt = TTY::Prompt.new(enable_color: true)

  def self.create
    result = @prompt.collect do
      key(:tileset_id).ask('Enter the ID for the tileset to be created or replaced:', help: "The ID is composed of your username followed by a period and the tileset\'s unique name")
      key(:recipe).ask('Enter the full path (i.e. /Users/name/folder/recipe.json) to your recipe:')
      key(:name).ask('Name of your tileset:', help: "Limited to 64 characters")
      key(:private).ask('Optional: Do you want your tileset to be public or limited to your access tokens only?', help: 'True or false - defaults to true', default: true)
      key(:description).ask('Optional: Description of your tileset:', help: 'Limited to 64 characters')
    end

    puts "Working..."

    recipe = File.open(result[:recipe])
    createTileset = HTTP.use(logging: {logger: Logger.new(STDOUT)}).headers(:content_type => "application/json").post("#{ENV['BASE_URL']}/#{result[:tileset_id]}", :params => {:access_token => ENV['ACCESS_TOKEN']}, 
    :json => {
      :recipe => JSON.load(recipe),
      :name => result[:name],
      :private => result[:private]
    })

    if createTileset.code != 200
      puts "Uh oh! You're hitting a #{createTileset.status} error. Look into the docs, then try running this script again. Here's the full response: \n #{createTileset.body.to_s}"
    else
      puts "Success! Here are the details you seek: \n #{createTileset.body.to_s}"
    end

    Index.restart
  end

  def self.publish
    puts "Working..."

    result = @prompt.collect do
      key(:tileset_id).ask('Enter the ID for the tileset to be published:', help: "The ID is composed of your username followed by a period and the tileset\'s unique name")
    end

    puts "Working..."

    publishTileset = HTTP.post("#{ENV['BASE_URL']}/#{result[:tileset_id]}/publish", :params => {:access_token => ENV['ACCESS_TOKEN']})
    ## Tilesets API returns 201 when successfully deleted
    if publishTileset.code != 200
      puts "Uh oh! You're hitting a #{publishTileset.status} error. Look into the docs, then try running this script again. Here's the full response: \n #{publishTileset.body.to_s}"
    else
      puts "Success! Here are the details you seek: \n #{publishTileset.body.to_s}" 
    end

    Index.restart
  end

  def self.status
    puts "Working..."

    result = @prompt.collect do
      key(:tileset_id).ask('Enter the ID for the tileset whose status you want to check:', help: "The ID is composed of your username followed by a period and the tileset\'s unique name")
    end

    puts "Working..."

    tilesetStatus = HTTP.get("#{ENV['BASE_URL']}/#{result[:tileset_id]}/status", :params => {:access_token => ENV['ACCESS_TOKEN']})
    ## Tilesets API returns 201 when successfully deleted
    if tilesetStatus.code != 200
      puts "Uh oh! You're hitting a #{tilesetStatus.status} error. Look into the docs, then try running this script again. Here's the full response: \n #{tilesetStatus.body.to_s}"
    else
      puts "Success! Here are the details you seek: \n #{tilesetStatus.body.to_s}" 
    end

    Index.restart
  end
end