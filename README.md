# minitest-openapi
Generate OpenAPI schema from MiniTest request specs. `minitest-openapi` 
is inspired by [rspec-openapi](https://github.com/exoego/rspec-openapi).

## Installation
```
gem 'minitest-openapi', '~> 0.0.1'
```

## Getting started
To use `minitest-openapi`, add `require 'minitest/openapi'` to 
the top of your request spec, and the `document!` method at the top of 
your class declaration.

The `document!` method can take in one of a few 'descriptors': `:path`, `:webhook`,
or `:component`. The `:path` descriptor is set by default if nothing is passed in.

```rb
require 'minitest/openapi'

class WebhookControllerTest < ActionDispatch::IntegrationTest
  document! :webhook

  test "POST /webhook" do
    post webhook_path
    assert_response :success
  end
end
```

## Configuration
To configure how your code will interact with `minitest-openapi`, 
create a new file in `config/initializers` (ex: `config/initializers/openapi.rb`).

```rb
require 'minitest/openapi'

Minitest::OpenAPI.path = 'docs/openapi.json'
```

## Run 
Running: 
```bash
DOC=1 bundle exec rails t
```

will generate a `.json` file. This file will either be called
`docs/openapi.json` (default), or the custom path you passed into the initializer
if on exists.

```json
{
  "openapi": "3.0.3",
  "info": {
    "title": "minitest-openapi"
  },
  "paths": {
    "/": {
      "get": {
        "description": "Example #1"
      }
    }
  },
  "webhooks": {
    "/github": {
      "post": {
        "description": "Example #2"
      }
    }
  },
  "components": {
    "schema": {
      "User": {
        "required": ["id"]
      }
    }
  }
}
```