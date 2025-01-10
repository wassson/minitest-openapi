Minitest::OpenAPI.info = {
  title: "Petstore API",
  description: "API documentation for the Petstore app.",
  version: "0.1.9"
}

Minitest::OpenAPI.servers << {
  url: "http://localhost:3000",
  description: "Main (production) server."
}
