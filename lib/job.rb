require 'tty-prompt'
require 'dotenv/load'
require 'http'

class Job
  @prompt = TTY::Prompt.new(enable_color: true)

  def self.list_all
    puts "Working..."

    result = @prompt.collect do
      key(:tileset_id).ask("Enter the tileset ID:", help: "The ID is composed of your username followed by a period and the tileset\'s unique name")
      key(:stage).select("Query for jobs at a specific processing stage:", %w(all processing queued success failed))
    end

    puts "Working..."

    if result[:stage] = "all"
      allJobs = HTTP.get("#{ENV['BASE_URL']}/#{result[:tileset_id]}/jobs", :params => {:access_token => ENV['ACCESS_TOKEN']})
    else
      allJobs = HTTP.get("#{ENV['BASE_URL']}/#{result[:tileset_id]}/jobs", :params => {:stage => result[:stage], :access_token => ENV['ACCESS_TOKEN']})
    end
    
    ## Tilesets API returns 201 when successfully deleted
    if allJobs.code != 200
      puts "Uh oh! You're hitting a #{allJobs.status} error. Look into the docs, then try running this script again. Here's the full response: \n #{allJobs.body.to_s}"
    else
      puts "Success! Here are the details you seek: \n #{allJobs.body.to_s}" 
    end
  end

  def self.retrieve_single
    puts "Working..."

    result = @prompt.collect do
      key(:tileset_id).ask('Enter the tileset ID:', help: "The ID is composed of your username followed by a period and the tileset\'s unique name")
      key(:job_id).ask('Enter the ID for the job belonging to the tileset whose status you want to check:')
    end

    puts "Working..."

    singleJobStatus = HTTP.get("#{ENV['BASE_URL']}/#{result[:tileset_id]}/jobs/#{result[:job_id]}", :params => {:access_token => ENV['ACCESS_TOKEN']})
    if singleJobStatus.code != 200
      puts "Uh oh! You're hitting a #{singleJobStatus.status} error. Look into the docs, then try running this script again. Here's the full response: \n #{singleJobStatus.body.to_s}"
    else
      puts "Success! Here are the details you seek: \n #{singleJobStatus.body.to_s}" 
    end
  end
end