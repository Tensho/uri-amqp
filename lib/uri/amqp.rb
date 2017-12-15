require "uri/generic"

module URI
  class AMQP < Generic
    VERSION = "0.1.0"

    DEFAULT_PORT = 5672

    COMPONENT = %i[
      scheme
      userinfo host port
      vhost
      heartbeat
      connection_timeout
      channel_max
      verify
      fail_if_no_peer_cert
      cacertfile
    ].freeze

    def initialize(*arg)
      super(*arg)

      parse_path
      parse_query
    end

    attr_reader :vhost, :heartbeat, :connection_timeout, :channel_max, :verify, :fail_if_no_peer_cert, :cacertfile, :certfile, :keyfile

    def vhost=(value)
      check_vhost(value)
      set_vhost(value)
    end

    def heartbeat=(value)
      set_heartbeat(value)
    end

    def connection_timeout=(value)
      set_connection_timeout(value)
    end

    def channel_max=(value)
      set_channel_max(value)
    end

    def verify=(value)
      check_verify(value)
      set_verify(value)
    end

    def fail_if_no_peer_cert=(value)
      check_fail_if_no_peer_cert(value)
      set_fail_if_no_peer_cert(value)
    end

    def cacertfile=(value)
      check_cacertfile(value)
      set_cacertfile(value)
    end

    def certfile=(value)
      check_certfile(value)
      set_certfile(value)
    end

    def keyfile=(value)
      check_keyfile(value)
      set_keyfile(value)
    end

      # URI::AMQP doesn't have path
    def hierarchical?
      false
    end

    protected

    def set_userinfo(user, password = nil)
      user &&= CGI::unescape(user)
      password &&= CGI::unescape(password)
      super(user, password)
    end

    def set_user(value)
      super(value && CGI::unescape(value))
    end

    def set_host(value)
      super(value && CGI::unescape(value))
    end

    def set_vhost(value)
      @vhost = if value
        value.delete!('/')
        CGI::unescape(value)
      end
    end

    def set_heartbeat(value)
      @heartbeat = value && value.to_i
    end

    def set_connection_timeout(value)
      @connection_timeout = value && value.to_i
    end

    def set_channel_max(value)
      @channel_max = value && value.to_i
    end

    def set_verify(value)
      @verify = !!(value)
    end

    def set_fail_if_no_peer_cert(value)
      @fail_if_no_peer_cert = !!(value)
    end

    def set_cacertfile(value)
      @cacertfile = value
    end

    def set_certfile(value)
      @certfile = value
    end

    def set_keyfile(value)
      @keyfile = value
    end

    private

    def parse_path
      return if path.empty?

      self.vhost = @path.dup
    end

    def parse_query
      return if @query.nil?

      params = Hash[@query.scan(/(.+?)=([^&]+)&*/)]

      self.heartbeat = params["heartbeat"]
      self.connection_timeout = params["connection_timeout"]
      self.channel_max = params["channel_max"]
      self.verify = params["verify"]
      self.fail_if_no_peer_cert = params["fail_if_no_peer_cert"]
      self.cacertfile = params["cacertfile"]
      self.certfile = params["certfile"]
      self.keyfile = params["keyfile"]
    end

    def check_vhost(value)
      if value && !(value =~ %r{^/[^/]*$})
        raise InvalidComponentError, "bad vhost (expected only leading \"/\"): #{value}"
      end
    end

    def check_verify(value)
      if value
        raise InvalidComponentError, "bad verify (expected only in \"amqps\" schema): #{value}"
      end
    end

    def check_fail_if_no_peer_cert(value)
      if value
        raise InvalidComponentError, "bad fail_if_no_peer_cert (expected only in \"amqps\" schema): #{value}"
      end
    end

    def check_cacertfile(value)
      if value
        raise InvalidComponentError, "bad cacertfile (expected only in \"amqps\" schema): #{value}"
      end
    end

    def check_certfile(value)
      if value
        raise InvalidComponentError, "bad certfile (expected only in \"amqps\" schema): #{value}"
      end
    end

    def check_keyfile(value)
      if value
        raise InvalidComponentError, "bad keyfile (expected only in \"amqps\" schema): #{value}"
      end
    end
  end

  @@schemes["AMQP"] = AMQP
end
