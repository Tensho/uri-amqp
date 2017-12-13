require "uri/amqp"

# https://www.rabbitmq.com/uri-spec.html

RSpec.describe URI::AMQP do
  it "has a version number" do
    expect(URI::AMQP::VERSION).not_to be_nil
  end

  subject { URI.parse(uri) }

  context "amqp://user:pass@host:10000/vhost" do
    let(:uri) { "amqp://user:pass@host:10000/vhost" }

    specify do
      expect(subject.user).to eq("user")
      expect(subject.password).to eq("pass")
      expect(subject.host).to eq("host")
      expect(subject.port).to eq(10000)
      expect(subject.vhost).to eq("vhost")
    end
  end

  context "amqp://user%61:%61pass@ho%61st:10000/v%2fhost" do
    let(:uri) { "amqp://user%61:%61pass@ho%61st:10000/v%2fhost" }

    specify do
      expect(subject.user).to eq("usera")
      expect(subject.password).to eq("apass")
      expect(subject.host).to eq("hoast")
      expect(subject.port).to eq(10000)
      expect(subject.vhost).to eq("v/host")
    end
  end

  context "amqp://" do
    let(:uri) { "amqp://" }

    specify do
      expect(subject.user).to be_nil
      expect(subject.password).to be_nil
      expect(subject.host).to be_nil
      expect(subject.port).to eq(5672)
      expect(subject.vhost).to be_nil
    end
  end

  context "amqp://:@/" do
    let(:uri) { "amqp://:@/" }

    specify do
      expect(subject.user).to eq("")
      expect(subject.password).to eq("")
      expect(subject.host).to be_nil
      expect(subject.port).to eq(5672)
      expect(subject.vhost).to eq("")
    end
  end

  context "amqp://user@" do
    let(:uri) { "amqp://user@" }

    specify do
      expect(subject.user).to eq("user")
      expect(subject.password).to be_nil
      expect(subject.host).to be_nil
      expect(subject.port).to eq(5672)
      expect(subject.vhost).to be_nil
    end
  end

  context "amqp://user:pass@" do
    let(:uri) { "amqp://user:pass@" }

    specify do
      expect(subject.user).to eq("user")
      expect(subject.password).to eq("pass")
      expect(subject.host).to be_nil
      expect(subject.port).to eq(5672)
      expect(subject.vhost).to be_nil
    end
  end

  context "amqp://host" do
    let(:uri) { "amqp://host" }

    specify do
      expect(subject.user).to be_nil
      expect(subject.password).to be_nil
      expect(subject.host).to eq("host")
      expect(subject.port).to eq(5672)
      expect(subject.vhost).to be_nil
    end
  end

  context "amqp://:10000" do
    let(:uri) { "amqp://:10000" }

    specify do
      expect(subject.user).to be_nil
      expect(subject.password).to be_nil
      expect(subject.host).to be_nil
      expect(subject.port).to eq(10000)
      expect(subject.vhost).to be_nil
    end
  end

  context "amqp:///vhost" do
    let(:uri) { "amqp:///vhost" }

    specify do
      expect(subject.user).to be_nil
      expect(subject.password).to be_nil
      expect(subject.host).to be_nil
      expect(subject.port).to eq(5672)
      expect(subject.vhost).to eq("vhost")
    end
  end

  context "amqp://host/" do
    let(:uri) { "amqp://host/" }

    specify do
      expect(subject.user).to be_nil
      expect(subject.password).to be_nil
      expect(subject.host).to eq("host")
      expect(subject.port).to eq(5672)
      expect(subject.vhost).to eq("")
    end
  end

  context "amqp://host/%2f" do
    let(:uri) { "amqp://host/%2f" }

    specify do
      expect(subject.user).to be_nil
      expect(subject.password).to be_nil
      expect(subject.host).to eq("host")
      expect(subject.port).to eq(5672)
      expect(subject.vhost).to eq("/")
    end
  end

  context "amqp://[::1]" do
    let(:uri) { "amqp://[::1]" }

    specify do
      expect(subject.user).to be_nil
      expect(subject.password).to be_nil
      expect(subject.host).to eq("[::1]")
      expect(subject.port).to eq(5672)
      expect(subject.vhost).to be_nil
    end
  end

  context "amqp://user:pass@host:10000/vhost/hurricane" do
    let(:uri) { "amqp://user:pass@host:10000/vhost/hurricane" }

    specify do
      expect { subject }.to raise_error(URI::InvalidComponentError, /bad vhost \(expected only leading '\/'\)/)
    end
  end

  context "amqp://user:pass@host:10000/vhost?heartbeat=10" do
    let(:uri) { "amqp://user:pass@host:10000/vhost?heartbeat=10" }
  end
end
