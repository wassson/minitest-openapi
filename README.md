# minitest-openapi
Generate OpenAPI schema from MiniTest request specs. `minitest-openapi` 
is inspired by [rspec-openapi](https://github.com/exoego/rspec-openapi).

## Installation
```gem 'minitest-openapi', '~> 0.0.1'```

## Getting started
To use `minitest-openapi`, add `require 'minitest/openapi'` to 
the top of your request spec, and `openapi!` at the top of 
your class declaration.

## Run 
Run with: ```DOC=1 bundle exec rails t```