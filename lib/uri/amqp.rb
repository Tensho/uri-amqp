require "uri/generic"

module URI
  class AMQP < Generic
    VERSION = "0.1.0"

    DEFAULT_PORT = 5672

    COMPONENT = %i[
      scheme
      userinfo host port
      path
      query
    ].freeze
  end

  @@schemes["AMQP"] = AMQP
end
