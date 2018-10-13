# frozen_string_literal: true

require "uri/amqp"

# https://www.rabbitmq.com/protocol.html
# https://www.rabbitmq.com/uri-spec.html
# https://www.rabbitmq.com/uri-query-parameters.html
# https://www.rabbitmq.com/ssl.html
module URI
  class AMQPS < AMQP
    DEFAULT_PORT = 5671

    # rubocop:disable Naming/UncommunicativeMethodParamName
    def check_verify(_); end

    def check_fail_if_no_peer_cert(_); end

    def check_cacertfile(_); end

    def check_certfile(_); end

    def check_keyfile(_); end
    # rubocop:enable Naming/UncommunicativeMethodParamName
  end

  @@schemes["AMQPS"] = AMQPS
end
