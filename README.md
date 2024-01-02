# minitest-openapi
Generate OpenAPI schema from MiniTest request specs. `minitest-openapi` 
is inspired by [rspec-openapi](https://github.com/exoego/rspec-openapi).

## Installation
```
gem 'minitest-openapi', '~> 0.0.1'
```

## Getting started
To use `minitest-openapi`, add `require 'minitest/openapi'` to 
the top of your request spec, and `document!` at the top of 
your class declaration.

## Configuration
To configure how your code will interact with `minitest-openapi`, 
create a new file in `config/initializers` (ex: `config/initializers/openapi.rb`).

```rb
require 'minitest/openapi'

Minitest::OpenAPI.path = 'docs/openapi.yaml'
```

## Run 
Running: 
```bash
DOC=1 bundle exec rails t
```

will generate a `yaml` file like:

```yaml
# docs/openapi.yaml
openapi: 3.0.3
info: 
  title: minitest-openapi
paths: 
  '/':
    get:
      summary: index
```