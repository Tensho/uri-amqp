require "uri/amqp"

# https://www.rabbitmq.com/uri-spec.html

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

  context "amqp://user:pass@host:10000/vhost/hurricane" do
    let(:uri) { "amqp://user:pass@host:10000/vhost/hurricane" }

    specify do
      expect { subject }.to raise_error(URI::InvalidComponentError, /bad vhost \(expected only leading '\/'\)/)
    end
  end
end
