require 'http'
require 'dotenv/load'
require 'tty-prompt'
require_relative 'tileset_source'
require_relative 'tileset'
require_relative 'job'
require_relative 'recipe'
require_relative 'converter'

class Index
  @prompt = TTY::Prompt.new(enable_color: true)

  def self.choice
    result = @prompt.collect do
    
      key(:choice).select("What would you like to do?", help: "There are a lot of options - keep scrolling") do |menu|
        menu.choice 'Create a tileset source', 1
        menu.choice 'Create a tileset', 2
        menu.choice 'Publish a tileset', 3
        menu.choice 'Retrieve the status of a tileset', 4
        menu.choice 'Retrieve tileset source information', 5
        menu.choice 'List tileset sources', 6
        menu.choice 'Delete a tileset source', 7
        menu.choice 'Validate a recipe', 8
        menu.choice 'Update a tileset\'s recipe', 9
        menu.choice 'Retrieve a tileset\'s recipe', 10
        menu.choice 'List information about all jobs for a tileset', 11
        menu.choice 'Retrieve information about a single tileset job', 12
        menu.choice 'Convert GeoJSON to line-delimited GeoJSON (requires Tippecanoe)', 13
      end
    end

    case result[:choice]
    when 1
      TilesetSource.create
    when 2
      Tileset.create
    when 3
      Tileset.publish
    when 4
      Tileset.status
    when 5
      TilesetSource.retrieve
    when 6
      TilesetSource.list
    when 7
      TilesetSource.delete
    when 8
      Recipe.validate
    when 9
      Recipe.update
    when 10
      Recipe.retrieve
    when 11
      Job.list_all
    when 12
      Job.retrieve_single
    when 13
      Converter.convert
    else
      "Error: not found"
    end
  end

  def self.restart
    result = @prompt.collect do
      key(:restart).yes?('Do you want to make another request?')
    end

    if result[:restart] == true
      choice
    else
      ## exit
    end
  end
# def self.error_handling(endpoint)
# ## add universal error handling
#   if endpoint.code != 200
#     puts "Uh oh! You're hitting a #{retrieveSource.status} error. Look into the docs, then try running this script again. Here's the full response: \n #{retrieveSource.body.to_s}"
#   end
# end

choice
end