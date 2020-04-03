## A Ruby CLI for Mapbox's Tilesets API

- [A Ruby CLI for Mapbox's Tilesets API](#a-ruby-cli-for-mapboxs-tilesets-api)
  - [Getting started](#getting-started)
  - [Documentation](#documentation)
  - [Advanced](#advanced)
    - [Logging](#logging)
  - [Contributing](#contributing)
  - [Known issues](#known-issues)

Hi there! Mapbox has a powerful [Tilesets API](https://docs.mapbox.com/api/maps/#tilesets). There's also a Python-based [CLI tool](https://github.com/mapbox/tilesets-cli/), but this library strives to provide another option for the Rubyists among us.

### Getting started
1. Clone this repo locally.
2. Create a `.env` file and set a **username**, **access_token**, and **base_url**. Your `.env` file should look like this:
```
ACCESS_TOKEN={your-properly-scoped-access-token-here}
USERNAME={your-mapbox-username}
BASE_URL=https://api.mapbox.com/tilesets/v1
``` 
3. Run `bundle install` in the repo directory.
4. Run `ruby lib/index.rb`.

### Documentation
Your best bet is going to be to read the [Tilesets API documentation](https://docs.mapbox.com/api/maps/#tilesets). This CLI mirrors the functionality offered there, including all available parameters. The following endpoints are available in this CLI:

- [Create a tileset source](https://docs.mapbox.com/api/maps/#create-a-tileset-source)
- [Retrieve tileset source information](https://docs.mapbox.com/api/maps/#retrieve-tileset-source-information)
- [List tileset sources](https://docs.mapbox.com/api/maps/#list-tileset-sources)
- [Delete a tileset source](https://docs.mapbox.com/api/maps/#delete-a-tileset-source)
- [Create a tileset](https://docs.mapbox.com/api/maps/#create-a-tileset)
- [Publish a tileset](https://docs.mapbox.com/api/maps/#publish-a-tileset)
- [Update a tileset](https://docs.mapbox.com/api/maps/#update-a-tileset)
- [Retrieve the status of a tileset](https://docs.mapbox.com/api/maps/#retrieve-the-status-of-a-tileset)
- [Retrieve information about a single tileset job](https://docs.mapbox.com/api/maps/#retrieve-information-about-a-single-tileset-job)
- [List information about all jobs for a tileset](https://docs.mapbox.com/api/maps/#list-information-about-all-jobs-for-a-tileset)
- [Validate a recipe](https://docs.mapbox.com/api/maps/#validate-a-recipe)
- [Retrieve a tileset's recipe](https://docs.mapbox.com/api/maps/#retrieve-a-tilesets-recipe)
- [Update a tileset's recipe](https://docs.mapbox.com/api/maps/#update-a-tilesets-recipe)

The following endpoints **are not yet** available in this CLI:

- [View the Tilesets API global queue](https://docs.mapbox.com/api/maps/#view-the-tilesets-api-global-queue)
  
### Advanced
#### Logging
If you're running into errors and can't figure out why, you can enable logging to see the full HTTP request. Navigate to the line of code where the request is being made and modify the HTTP request like so:

`HTTP.use(logging: {logger: Logger.new(STDOUT)}).get`

At the top of the file you're editing, add the following line: `require 'logger'`

Then re-run.

### Contributing
Feel free to contribute! Fork the library and make your own changes, then merge them back in. Or just create your own branch, make some changes, and set up a PR.

### Known issues
- It's a bit annoying to enable logging manually. I'd like to add a parameter at the start (or an env variable) that would turn it on/off globally.