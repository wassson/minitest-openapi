# app/models/api_error.rb

class ApiError
  attr_reader :code, :message

  def initialize(code, message)
    @code = code
    @message = message
  end

  def as_json(options = {})
    {
      code: code,
      message: message
    }
  end
end
