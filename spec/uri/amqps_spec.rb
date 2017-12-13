require "uri/amqps"

# https://www.rabbitmq.com/uri-spec.html

RSpec.describe URI::AMQPS do
  subject { URI.parse(uri) }

  context "amqps://user:pass@host:10000/vhost" do
    let(:uri) { "amqps://user:pass@host:10000/vhost" }

    specify do
      expect(subject.user).to eq("user")
      expect(subject.password).to eq("pass")
      expect(subject.host).to eq("host")
      expect(subject.port).to eq(10000)
      expect(subject.vhost).to eq("vhost")
    end
  end

  context "amqps://user%61:%61pass@ho%61st:10000/v%2fhost" do
    let(:uri) { "amqps://user%61:%61pass@ho%61st:10000/v%2fhost" }

    specify do
      expect(subject.user).to eq("usera")
      expect(subject.password).to eq("apass")
      expect(subject.host).to eq("hoast")
      expect(subject.port).to eq(10000)
      expect(subject.vhost).to eq("v/host")
    end
  end

  context "amqps://" do
    let(:uri) { "amqps://" }

    specify do
      expect(subject.user).to be_nil
      expect(subject.password).to be_nil
      expect(subject.host).to be_nil
      expect(subject.port).to eq(5671)
      expect(subject.vhost).to be_nil
    end
  end

  context "amqps://:@/" do
    let(:uri) { "amqps://:@/" }

    specify do
      expect(subject.user).to eq("")
      expect(subject.password).to eq("")
      expect(subject.host).to be_nil
      expect(subject.port).to eq(5671)
      expect(subject.vhost).to eq("")
    end
  end

  context "amqps://user@" do
    let(:uri) { "amqps://user@" }

    specify do
      expect(subject.user).to eq("user")
      expect(subject.password).to be_nil
      expect(subject.host).to be_nil
      expect(subject.port).to eq(5671)
      expect(subject.vhost).to be_nil
    end
  end

  context "amqps://user:pass@" do
    let(:uri) { "amqps://user:pass@" }

    specify do
      expect(subject.user).to eq("user")
      expect(subject.password).to eq("pass")
      expect(subject.host).to be_nil
      expect(subject.port).to eq(5671)
      expect(subject.vhost).to be_nil
    end
  end

  context "amqps://host" do
    let(:uri) { "amqps://host" }

    specify do
      expect(subject.user).to be_nil
      expect(subject.password).to be_nil
      expect(subject.host).to eq("host")
      expect(subject.port).to eq(5671)
      expect(subject.vhost).to be_nil
    end
  end

  context "amqps://:10000" do
    let(:uri) { "amqps://:10000" }

    specify do
      expect(subject.user).to be_nil
      expect(subject.password).to be_nil
      expect(subject.host).to be_nil
      expect(subject.port).to eq(10000)
      expect(subject.vhost).to be_nil
    end
  end

  context "amqps:///vhost" do
    let(:uri) { "amqps:///vhost" }

    specify do
      expect(subject.user).to be_nil
      expect(subject.password).to be_nil
      expect(subject.host).to be_nil
      expect(subject.port).to eq(5671)
      expect(subject.vhost).to eq("vhost")
    end
  end

  context "amqps://host/" do
    let(:uri) { "amqps://host/" }

    specify do
      expect(subject.user).to be_nil
      expect(subject.password).to be_nil
      expect(subject.host).to eq("host")
      expect(subject.port).to eq(5671)
      expect(subject.vhost).to eq("")
    end
  end

  context "amqps://host/%2f" do
    let(:uri) { "amqps://host/%2f" }

    specify do
      expect(subject.user).to be_nil
      expect(subject.password).to be_nil
      expect(subject.host).to eq("host")
      expect(subject.port).to eq(5671)
      expect(subject.vhost).to eq("/")
    end
  end

  context "amqps://[::1]" do
    let(:uri) { "amqps://[::1]" }

    specify do
      expect(subject.user).to be_nil
      expect(subject.password).to be_nil
      expect(subject.host).to eq("[::1]")
      expect(subject.port).to eq(5671)
      expect(subject.vhost).to be_nil
    end
  end

  context "amqps://user:pass@host:10000/vhost/hurricane" do
    let(:uri) { "amqps://user:pass@host:10000/vhost/hurricane" }

    specify do
      expect { subject }.to raise_error(URI::InvalidComponentError, /bad vhost \(expected only leading '\/'\)/)
    end
  end
end
