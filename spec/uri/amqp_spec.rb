require "uri/amqp"

# https://www.rabbitmq.com/uri-spec.html
# https://www.rabbitmq.com/uri-query-parameters.html
# https://www.rabbitmq.com/ssl.html

RSpec.describe URI::AMQP do
  it "has a version number" do
    expect(URI::AMQP::VERSION).not_to be_nil
  end

  subject { URI.parse(uri) }

  context "amqp://user:pass@host:10000/vhost" do
    let(:uri) { "amqp://user:pass@host:10000/vhost" }

    its(:user) { is_expected.to eq("user") }
    its(:password) { is_expected.to eq("pass") }
    its(:host) { is_expected.to eq("host") }
    its(:port) { is_expected.to eq(10000) }
    its(:vhost) { is_expected.to eq("vhost") }
  end

  context "amqp://user%61:%61pass@ho%61st:10000/v%2fhost" do
    let(:uri) { "amqp://user%61:%61pass@ho%61st:10000/v%2fhost" }

    its(:user) { is_expected.to eq("usera") }
    its(:password) { is_expected.to eq("apass") }
    its(:host) { is_expected.to eq("hoast") }
    its(:port) { is_expected.to eq(10000) }
    its(:vhost) { is_expected.to eq("v/host") }
  end

  context "amqp://" do
    let(:uri) { "amqp://" }

    its(:user) { is_expected.to be_nil }
    its(:password) { is_expected.to be_nil }
    its(:host) { is_expected.to be_nil }
    its(:port) { is_expected.to eq(5672) }
    its(:vhost) { is_expected.to be_nil }
  end

  context "amqp://:@/" do
    let(:uri) { "amqp://:@/" }

    its(:user) { is_expected.to eq("") }
    its(:password) { is_expected.to eq("") }
    its(:host) { is_expected.to be_nil }
    its(:port) { is_expected.to eq(5672) }
    its(:vhost) { is_expected.to eq("") }
  end

  context "amqp://user@" do
    let(:uri) { "amqp://user@" }

    its(:user) { is_expected.to eq("user") }
    its(:password) { is_expected.to be_nil }
    its(:host) { is_expected.to be_nil }
    its(:port) { is_expected.to eq(5672) }
    its(:vhost) { is_expected.to be_nil }
  end

  context "amqp://user:pass@" do
    let(:uri) { "amqp://user:pass@" }

    its(:user) { is_expected.to eq("user") }
    its(:password) { is_expected.to eq("pass") }
    its(:host) { is_expected.to be_nil }
    its(:port) { is_expected.to eq(5672) }
    its(:vhost) { is_expected.to be_nil }
  end

  context "amqp://host" do
    let(:uri) { "amqp://host" }

    its(:user) { is_expected.to be_nil }
    its(:password) { is_expected.to be_nil }
    its(:host) { is_expected.to eq("host") }
    its(:port) { is_expected.to eq(5672) }
    its(:vhost) { is_expected.to be_nil }
  end

  context "amqp://:10000" do
    let(:uri) { "amqp://:10000" }

    its(:user) { is_expected.to be_nil }
    its(:password) { is_expected.to be_nil }
    its(:host) { is_expected.to be_nil }
    its(:port) { is_expected.to eq(10000) }
    its(:vhost) { is_expected.to be_nil }
  end

  context "amqp:///vhost" do
    let(:uri) { "amqp:///vhost" }

    its(:user) { is_expected.to be_nil }
    its(:password) { is_expected.to be_nil }
    its(:host) { is_expected.to be_nil }
    its(:port) { is_expected.to eq(5672) }
    its(:vhost) { is_expected.to eq("vhost") }
  end

  context "amqp://host/" do
    let(:uri) { "amqp://host/" }

    its(:user) { is_expected.to be_nil }
    its(:password) { is_expected.to be_nil }
    its(:host) { is_expected.to eq("host") }
    its(:port) { is_expected.to eq(5672) }
    its(:vhost) { is_expected.to eq("") }
  end

  context "amqp://host/%2f" do
    let(:uri) { "amqp://host/%2f" }

    its(:user) { is_expected.to be_nil }
    its(:password) { is_expected.to be_nil }
    its(:host) { is_expected.to eq("host") }
    its(:port) { is_expected.to eq(5672) }
    its(:vhost) { is_expected.to eq("/") }
  end

  context "amqp://[::1]" do
    let(:uri) { "amqp://[::1]" }

    its(:user) { is_expected.to be_nil }
    its(:password) { is_expected.to be_nil }
    its(:host) { is_expected.to eq("[::1]") }
    its(:port) { is_expected.to eq(5672) }
    its(:vhost) { is_expected.to be_nil }
  end

  context "amqp:///vhost/hurricane" do
    let(:uri) { "amqp:///vhost/hurricane" }

    specify do
      expect { subject }.to raise_error(URI::InvalidComponentError, /bad vhost \(expected only leading "\/"\)/)
    end
  end

  # All attributes are present
  context "amqp://user:pass@host/vhost?heartbeat=10&connection_timeout=10000" do
    let(:uri) { "amqp://user:pass@host/vhost?heartbeat=10&connection_timeout=100&channel_max=1000" }

    its(:user) { is_expected.to eq("user") }
    its(:password) { is_expected.to eq("pass") }
    its(:host) { is_expected.to eq("host") }
    its(:port) { is_expected.to eq(5672) }
    its(:vhost) { is_expected.to eq("vhost") }
    its(:heartbeat) { is_expected.to eq(10) }
    its(:connection_timeout) { is_expected.to eq(100) }
    its(:channel_max) { is_expected.to eq(1000) }
  end

  # Part of attributes are present
  context "amqp://user:pass@host/vhost?connection_timeout=100" do
    let(:uri) { "amqp://user:pass@host/vhost?connection_timeout=100" }

    its(:user) { is_expected.to eq("user") }
    its(:password) { is_expected.to eq("pass") }
    its(:host) { is_expected.to eq("host") }
    its(:port) { is_expected.to eq(5672) }
    its(:vhost) { is_expected.to eq("vhost") }
    its(:heartbeat) { is_expected.to be_nil }
    its(:connection_timeout) { is_expected.to eq(100) }
    its(:channel_max) { is_expected.to be_nil }
  end

  context "amqp://user:pass@host/vhost?connection_timeout=100" do
    let(:uri) { "amqp://user:pass@host/vhost?connection_timeout=100" }

    its(:user) { is_expected.to eq("user") }
    its(:password) { is_expected.to eq("pass") }
    its(:host) { is_expected.to eq("host") }
    its(:port) { is_expected.to eq(5672) }
    its(:vhost) { is_expected.to eq("vhost") }
    its(:heartbeat) { is_expected.to be_nil }
    its(:connection_timeout) { is_expected.to eq(100) }
    its(:channel_max) { is_expected.to be_nil }
  end

  context "amqp://host?verify=true" do
    let(:uri) { "amqp://host?verify=true" }

    specify do
      expect { subject }.to raise_error(URI::InvalidComponentError, /bad verify \(expected only in "amqps" schema\)/)
    end
  end

  context "amqp://host?fail_if_no_peer_cert=true" do
    let(:uri) { "amqp://host?fail_if_no_peer_cert=true" }

    specify do
      expect { subject }.to raise_error(URI::InvalidComponentError, /bad fail_if_no_peer_cert \(expected only in "amqps" schema\)/)
    end
  end

  context "amqp://host?cacertfile=/examples/tls/cacert.pem" do
    let(:uri) { "amqp://host?cacertfile=/examples/tls/cacert.pem" }

    specify do
      expect { subject }.to raise_error(URI::InvalidComponentError, /bad cacertfile \(expected only in "amqps" schema\)/)
    end
  end

  context "amqp://host?certfile=/examples/tls/client_cert.pem" do
    let(:uri) { "amqp://host?certfile=/examples/tls/client_cert.pem" }

    specify do
      expect { subject }.to raise_error(URI::InvalidComponentError, /bad certfile \(expected only in "amqps" schema\)/)
    end
  end

  context "amqp://host?keyfile=/examples/tls/client_key.pem" do
    let(:uri) { "amqp://host?keyfile=/examples/tls/client_key.pem" }

    specify do
      expect { subject }.to raise_error(URI::InvalidComponentError, /bad keyfile \(expected only in "amqps" schema\)/)
    end
  end
end
