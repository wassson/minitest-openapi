# minitest-openapi
Generate OpenAPI schema from MiniTest request specs. `minitest-openapi`
is inspired by [rspec-openapi](https://github.com/exoego/rspec-openapi).

## Installation
```
gem 'minitest-openapi', '~> 0.0.2'
```

Note: 0.0.2 excludes some core features required by OpenAPI v3.1

## Getting started
To use `minitest-openapi`, add `require 'minitest/openapi'` to
the top of your request spec (if you're not using an initializer), and `include OpenAPI`
at the top of your class declaration.

By default, test cases are evaluated as `paths`. That is,
they're not `webhooks`. If a test case is testing a
`webhook`, call `webhook!` within the test block. Note: `components`
are not currently supported, but `components` are expected to launch
with `v0.1`.

```rb
class PetsControllerTest < ActionDispatch::IntegrationTest
  include MiniAPI

  setup do
    @pet = pets(:one)
  end

  test "will get /pets" do
    description "Returns a list of pets"
    response_schema { "$ref" => "#/components/schemas/Pets" }

    get pets_url, as: :json
    assert_response :success
  end
end
```

## Configuration
To configure how your code will interact with `minitest-openapi`,
create a new file in `config/initializers` (ex: `config/initializers/openapi.rb`).

```rb
require 'minitest/openapi'

# For non-versioned APIs
Minitest::OpenAPI.path = 'docs/openapi.json'

# For versioned APIs
Minitest::OpenAPI.path = ->(test_case) {
  case test_case.path
  when %r[controllers/api/v1] then 'docs/openapi/v1.json'
  when %r[controllers/api/v2] then 'docs/openapi/v2.json'
  else 'docs/openapi.json'
  end
}

# Your project metadata
Minitest::OpenAPI.info = {
  title: "Petstore API",
  description: "API documentation for the Petstore app.",
  version: "0.1.9"
}

Minitest::OpenAPI.servers << {
  url: "http://localhost:3000",
  description: "Main (production) server."
}

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
    "version": "1.2.3",
    "title": "minitest-openapi",
    "license": {
      "name": "MIT",
      "url": "https://opensource.org/licenses/MIT"
    }
  },
  "paths": {
    "/pets": {
      "get": {
        "summary": "Example #1",
        "operationId": "listPets",
        "tags": [
          "pets"
        ],
        "parameters": [
          {
            "name": "limit",
            "in": "query",
            "description": "How many items to return at one time (max 100)",
            "required": false,
            "schema": {
              "type": "integer",
              "format": "int32"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "A paged array of pets",
            "headers": {
              "x-next": {
                "description": "A link to the next page of responses",
                "schema": {
                  "type": "string"
                }
              }
            },
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Pets"
                }
              }
            }
          },
          "default": {
            "description": "unexpected error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Error"
                }
              }
            }
          }
        }
      }
    }
  },
  "webhooks": { ... },
  "components": {
    "schema": {
      "Pet": {
        "required": ["id"]
      }
    }
  }
}
```
