require "uri/amqp"

module URI
  class AMQPS < AMQP
    DEFAULT_PORT = 5671
  end

  @@schemes["AMQPS"] = AMQPS
end
