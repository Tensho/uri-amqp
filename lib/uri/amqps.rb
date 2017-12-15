require "uri/amqp"

module URI
  class AMQPS < AMQP
    DEFAULT_PORT = 5671

    def check_verify(_)
    end

    def check_fail_if_no_peer_cert(_)
    end

    def check_cacertfile(_)
    end

    def check_certfile(_)
    end

    def check_keyfile(_)
    end
  end

  @@schemes["AMQPS"] = AMQPS
end
