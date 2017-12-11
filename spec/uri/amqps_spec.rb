require "uri/amqps"

RSpec.describe URI::AMQPS do
  let(:uri) { "amqps://user:pass@rabbitmq/staging?heartbeat=10" }
  subject { URI.parse(uri) }

  it { is_expected.to be_instance_of(URI::AMQPS) }

  describe "scheme" do
    it { expect(subject.scheme).to eq("amqps") }
  end

  describe "user info" do
    it { expect(subject.user).to eq("user") }
    it { expect(subject.password).to eq("pass") }
  end

  describe "host" do
    it { expect(subject.host).to eq("rabbitmq") }
  end

  describe "port" do
    it { expect(subject.port).to eq(5671) }
  end

  describe "path" do
    it { expect(subject.path).to eq("/staging") }
  end

  describe "query" do
    it { expect(subject.query).to eq("heartbeat=10") }
  end
end

