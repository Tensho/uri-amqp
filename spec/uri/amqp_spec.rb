require "uri/amqp"

RSpec.describe URI::AMQP do
  it "has a version number" do
    expect(URI::AMQP::VERSION).not_to be_nil
  end

  let(:uri) { "amqp://user:pass@rabbitmq/staging?heartbeat=10" }
  subject { URI.parse(uri) }

  it { is_expected.to be_instance_of(URI::AMQP) }

  describe "scheme" do
    it { expect(subject.scheme).to eq("amqp") }
  end

  describe "user info" do
    it { expect(subject.user).to eq("user") }
    it { expect(subject.password).to eq("pass") }
  end

  describe "host" do
    it { expect(subject.host).to eq("rabbitmq") }
  end

  describe "port" do
    it { expect(subject.port).to eq(5672) }
  end

  describe "path" do
    it { expect(subject.path).to eq("/staging") }
  end

  describe "query" do
    it { expect(subject.query).to eq("heartbeat=10") }
  end
end
