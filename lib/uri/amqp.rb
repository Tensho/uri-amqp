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
    ].freeze

    def initialize(*arg)
      super(*arg)

      parse_path
      parse_query
    end

    attr_reader :vhost, :heartbeat, :connection_timeout, :channel_max

    def heartbeat=(value)
      set_heartbeat(value)
    end

    def connection_timeout=(value)
      set_connection_timeout(value)
    end

    def channel_max=(value)
      set_channel_max(value)
    end

    def vhost=(value)
      check_vhost(value)
      set_vhost(value)
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

    private

    def parse_path
      return if path.empty?

      self.vhost = @path.dup
    end

    def parse_query
      return if @query.nil?

      params = Hash[@query.scan(/(.+?)=(\d+)&*/)]

      self.heartbeat = params["heartbeat"]
      self.connection_timeout = params["connection_timeout"]
      self.channel_max = params["channel_max"]
    end

    def check_vhost(value)
      if value && !(value =~ %r{^/[^/]*$})
        raise InvalidComponentError, "bad vhost (expected only leading '/'): #{value}"
      end
    end
  end

  @@schemes["AMQP"] = AMQP
end
