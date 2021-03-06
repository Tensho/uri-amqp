# frozen_string_literal: true

require "uri/amqps"

RSpec.describe URI::AMQPS do
  subject { URI.parse(uri) }

  context "amqps://user:pass@host:10000/vhost" do
    let(:uri) { "amqps://user:pass@host:10000/vhost" }

    its(:user) { is_expected.to eq("user") }
    its(:password) { is_expected.to eq("pass") }
    its(:host) { is_expected.to eq("host") }
    its(:port) { is_expected.to eq(10_000) }
    its(:vhost) { is_expected.to eq("vhost") }
  end

  context "amqps://user%61:%61pass@ho%61st:10000/v%2fhost" do
    let(:uri) { "amqps://user%61:%61pass@ho%61st:10000/v%2fhost" }

    its(:user) { is_expected.to eq("usera") }
    its(:password) { is_expected.to eq("apass") }
    its(:host) { is_expected.to eq("hoast") }
    its(:port) { is_expected.to eq(10_000) }
    its(:vhost) { is_expected.to eq("v/host") }
  end

  context "amqps://" do
    let(:uri) { "amqps://" }

    its(:user) { is_expected.to be_nil }
    its(:password) { is_expected.to be_nil }
    its(:host) { is_expected.to be_nil }
    its(:port) { is_expected.to eq(5671) }
    its(:vhost) { is_expected.to be_nil }
  end

  context "amqps://:@/" do
    let(:uri) { "amqps://:@/" }

    its(:user) { is_expected.to eq("") }
    its(:password) { is_expected.to eq("") }
    its(:host) { is_expected.to be_nil }
    its(:port) { is_expected.to eq(5671) }
    its(:vhost) { is_expected.to eq("") }
  end

  context "amqps://user@" do
    let(:uri) { "amqps://user@" }

    its(:user) { is_expected.to eq("user") }
    its(:password) { is_expected.to be_nil }
    its(:host) { is_expected.to be_nil }
    its(:port) { is_expected.to eq(5671) }
    its(:vhost) { is_expected.to be_nil }
  end

  context "amqps://user:pass@" do
    let(:uri) { "amqps://user:pass@" }

    its(:user) { is_expected.to eq("user") }
    its(:password) { is_expected.to eq("pass") }
    its(:host) { is_expected.to be_nil }
    its(:port) { is_expected.to eq(5671) }
    its(:vhost) { is_expected.to be_nil }
  end

  context "amqps://host" do
    let(:uri) { "amqps://host" }

    its(:user) { is_expected.to be_nil }
    its(:password) { is_expected.to be_nil }
    its(:host) { is_expected.to eq("host") }
    its(:port) { is_expected.to eq(5671) }
    its(:vhost) { is_expected.to be_nil }
  end

  context "amqps://:10000" do
    let(:uri) { "amqps://:10000" }

    its(:user) { is_expected.to be_nil }
    its(:password) { is_expected.to be_nil }
    its(:host) { is_expected.to be_nil }
    its(:port) { is_expected.to eq(10_000) }
    its(:vhost) { is_expected.to be_nil }
  end

  context "amqps:///vhost" do
    let(:uri) { "amqps:///vhost" }

    its(:user) { is_expected.to be_nil }
    its(:password) { is_expected.to be_nil }
    its(:host) { is_expected.to be_nil }
    its(:port) { is_expected.to eq(5671) }
    its(:vhost) { is_expected.to eq("vhost") }
  end

  context "amqps://host/" do
    let(:uri) { "amqps://host/" }

    its(:user) { is_expected.to be_nil }
    its(:password) { is_expected.to be_nil }
    its(:host) { is_expected.to eq("host") }
    its(:port) { is_expected.to eq(5671) }
    its(:vhost) { is_expected.to eq("") }
  end

  context "amqps://host/%2f" do
    let(:uri) { "amqps://host/%2f" }

    its(:user) { is_expected.to be_nil }
    its(:password) { is_expected.to be_nil }
    its(:host) { is_expected.to eq("host") }
    its(:port) { is_expected.to eq(5671) }
    its(:vhost) { is_expected.to eq("/") }
  end

  context "amqps://[::1]" do
    let(:uri) { "amqps://[::1]" }

    its(:user) { is_expected.to be_nil }
    its(:password) { is_expected.to be_nil }
    its(:host) { is_expected.to eq("[::1]") }
    its(:port) { is_expected.to eq(5671) }
    its(:vhost) { is_expected.to be_nil }
  end

  context "amqps://user:pass@host:10000/vhost/hurricane" do
    let(:uri) { "amqps://user:pass@host:10000/vhost/hurricane" }

    specify do
      expect { subject }.to raise_error(URI::InvalidComponentError, %r{bad vhost \(expected only leading "/"\)})
    end
  end

  # All attributes are present
  context "amqps://user:pass@host/vhost?heartbeat=10&connection_timeout=100&channel_max=1000&verify=true&fail_if_no_peer_cert=true&cacertfile=/examples/tls/cacert.pem&certfile=/examples/tls/client_cert.pem&keyfile=/examples/tls/client_key.pem" do
    let(:uri) { "amqps://user:pass@host/vhost?heartbeat=10&connection_timeout=100&channel_max=1000&verify=true&fail_if_no_peer_cert=true&cacertfile=/examples/tls/cacert.pem&certfile=/examples/tls/client_cert.pem&keyfile=/examples/tls/client_key.pem" }

    its(:user) { is_expected.to eq("user") }
    its(:password) { is_expected.to eq("pass") }
    its(:host) { is_expected.to eq("host") }
    its(:port) { is_expected.to eq(5671) }
    its(:vhost) { is_expected.to eq("vhost") }
    its(:heartbeat) { is_expected.to eq(10) }
    its(:connection_timeout) { is_expected.to eq(100) }
    its(:channel_max) { is_expected.to eq(1000) }
    its(:verify) { is_expected.to be_truthy }
    its(:fail_if_no_peer_cert) { is_expected.to be_truthy }
    its(:cacertfile) { is_expected.to eq("/examples/tls/cacert.pem") }
    its(:certfile) { is_expected.to eq("/examples/tls/client_cert.pem") }
    its(:keyfile) { is_expected.to eq("/examples/tls/client_key.pem") }
  end

  # Part of attributes are present
  context "amqps://user:pass@host/vhost?connection_timeout=100" do
    let(:uri) { "amqps://user:pass@host/vhost?connection_timeout=100" }

    its(:user) { is_expected.to eq("user") }
    its(:password) { is_expected.to eq("pass") }
    its(:host) { is_expected.to eq("host") }
    its(:port) { is_expected.to eq(5671) }
    its(:vhost) { is_expected.to eq("vhost") }
    its(:heartbeat) { is_expected.to be_nil }
    its(:connection_timeout) { is_expected.to eq(100) }
    its(:channel_max) { is_expected.to be_nil }
    its(:verify) { is_expected.to be_falsey }
    its(:fail_if_no_peer_cert) { is_expected.to be_falsey }
    its(:cacertfile) { is_expected.to be_nil }
    its(:certfile) { is_expected.to be_nil }
    its(:keyfile) { is_expected.to be_nil }
  end
end
