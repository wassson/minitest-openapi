# minitest-openai
Generate OpenAPI schema from MiniTest request specs.

## Getting started

To use `minitest-openapi`, add `require 'minitest/doc'` to 
the top of your request spec, and `openapi!` at the top of 
your class declaration.

Run with: `OPENAPI=1 bundle exec rails test`