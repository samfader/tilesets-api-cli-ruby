## To convert file from geojson to geojson.ld
## Must have Tippecanoe on computer

require 'tty-prompt'

class Converter
  @prompt = TTY::Prompt.new(enable_color: true)

  def self.convert
    result = @prompt.collect do
      key(:in_file).ask('Enter the full path (i.e. /Users/name/folder/file.geojson) to your GeoJSON file (make sure there\'s no space at the end) to convert it to line-delimited GeoJSON:')
    end

    ## executes as shell command
    `tippecanoe-json-tool #{result[:in_file].strip} > #{result[:in_file].strip + ".ld"}`

    Index.restart
  end
end