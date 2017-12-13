require "uri/generic"

module URI
  class AMQP < Generic
    VERSION = "0.1.0"

    DEFAULT_PORT = 5672

    COMPONENT = %i[
      scheme
      userinfo host port
      vhost
      query
    ].freeze

    def initialize(*arg)
      super(*arg)

      self.vhost = @path.empty? ? nil : @path.dup
    end

    def vhost
      @vhost
    end

    def vhost=(vhost)
      check_vhost(vhost)
      set_vhost(vhost)
    end

    private

    def check_vhost(vhost)
      if vhost && !(vhost =~ %r{^/[^/]*$})
        raise InvalidComponentError, "bad vhost (expected only leading '/'): #{vhost}"
      end
    end

    protected

    def set_userinfo(user, password = nil)
      user &&= CGI::unescape(user)
      password &&= CGI::unescape(password)
      super(user, password)
    end

    def set_user(user)
      super(user && CGI::unescape(user))
    end

    def set_host(host)
      super(host && CGI::unescape(host))
    end

    def set_vhost(vhost)
      @vhost = if vhost
        vhost.delete!('/')
        CGI::unescape(vhost)
      end
    end
  end

  @@schemes["AMQP"] = AMQP
end
